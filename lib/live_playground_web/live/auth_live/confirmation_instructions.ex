defmodule LivePlaygroundWeb.AuthLive.ConfirmationInstructions do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Accounts

  def mount(_params, _session, socket) do
    form = to_form(%{}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-zinc-100 min-h-screen flex flex-col justify-center sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="text-center text-2xl font-bold text-zinc-900">
          Need a new confirmation email?
        </h2>
        <p class="mt-2 text-center text-sm text-zinc-600">
          Already confirmed?
          <.link navigate={~p"/users/log_in"} class="font-semibold">
            Sign in
          </.link>
        </p>
      </div>

      <div class="mt-10 mb-20 sm:mx-auto sm:w-full sm:max-w-[480px]">
        <div class="bg-white bodrer border-zinc-300 px-6 pt-4 pb-12 shadow-sm sm:rounded-lg sm:px-12">
          <.simple_form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
            <.input field={@form[:email]} type="email" label="Email address" required autocomplete="email" />
            <:actions>
              <.button phx-disable-with="Sending..." class="w-full">
                Resend confirmation instructions
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

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
