defmodule LivePlaygroundWeb.AuthLive.Login do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-zinc-100 min-h-screen flex flex-col justify-center sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="text-center text-2xl font-bold text-zinc-900">
          Sign in to your account
        </h2>
        <p class="mt-2 text-center text-sm text-zinc-600">
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold">
            Sign up
          </.link>
        </p>
      </div>

      <div class="mt-10 mb-20 sm:mx-auto sm:w-full sm:max-w-[480px]">
        <div class="bg-white px-6 py-6 shadow-sm sm:rounded-lg sm:px-12">
          <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
            <.input field={@form[:email]} type="email" label="Email address" required autocomplete="email" />
            <.input field={@form[:password]} type="password" label="Password" required autocomplete="current-password" />

            <:actions>
              <.input field={@form[:remember_me]} type="checkbox" label="Remember me" />
              <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
                Forgot password?
              </.link>
            </:actions>
            <:actions>
              <.button phx-disable-with="Signing in..." class="w-full">
                Sign in
              </.button>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end
end
