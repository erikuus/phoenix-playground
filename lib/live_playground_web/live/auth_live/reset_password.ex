defmodule LivePlaygroundWeb.AuthLive.ResetPassword do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Accounts

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-zinc-100 min-h-screen flex flex-col justify-center sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="text-center text-2xl font-bold text-zinc-900">
          Reset your password
        </h2>
        <p class="mt-2 text-center text-sm text-zinc-600">
          Remembered it?
          <.link navigate={~p"/users/log_in"} class="font-semibold">
            Sign in
          </.link>
        </p>
      </div>

      <div class="mt-10 mb-20 sm:mx-auto sm:w-full sm:max-w-[480px]">
        <div class="bg-white bodrer border-zinc-300 px-6 pt-4 pb-12 shadow-sm sm:rounded-lg sm:px-12">
          <.simple_form
            for={@form}
            id="reset_password_form"
            phx-submit="reset_password"
            phx-change="validate"
          >
            <.error :if={@form.errors != []}>
              Oops, something went wrong! Please check the errors below.
            </.error>

            <.input field={@form[:password]} type="password" label="New password" required autocomplete="new-password" />
            <.input field={@form[:password_confirmation]} type="password" label="Confirm new password" required autocomplete="new-password" />

            <:actions>
              <.button phx-disable-with="Resetting..." class="w-full">
                Reset password
              </.button>
            </:actions>
          </.simple_form>

          <p class="mt-4 text-center text-sm text-zinc-600">
            Need an account?
            <.link navigate={~p"/users/register"} class="font-semibold">
              Sign up
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
