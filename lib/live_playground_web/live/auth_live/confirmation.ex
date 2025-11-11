defmodule LivePlaygroundWeb.AuthLive.Confirmation do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Accounts

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="bg-zinc-100 min-h-screen flex flex-col justify-center sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="text-center text-2xl font-bold text-zinc-900">
          Confirm your account
        </h2>
        <p class="mt-2 text-center text-sm text-zinc-600">
          Already confirmed?
          <.link navigate={~p"/users/log_in"} class="font-semibold">
            Sign in
          </.link>
        </p>
      </div>

      <div class="mt-10 mb-20 sm:mx-auto sm:w-full sm:max-w-[480px]">
        <div class="bg-white bodrer border-zinc-300 px-6 py-6 shadow-sm sm:rounded-lg sm:px-12">
          <.simple_form for={@form} id="confirmation_form" phx-submit="confirm_account">
            <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
            <:actions>
              <.button phx-disable-with="Confirming..." class="w-full">
                Confirm my account
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

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
