defmodule LivePlaygroundWeb.CompsLive.AuthMenuCustom do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :authenticated_user, nil)}
  end

  def handle_event("toggle_auth", _params, socket) do
    authenticated_user =
      if socket.assigns.authenticated_user do
        nil
      else
        %{
          email: "john.doe@example.com",
          inserted_at: ~N[2023-06-15 10:30:00]
        }
      end

    {:noreply, assign(socket, :authenticated_user, authenticated_user)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Auth Menu Customized
      <:subtitle>
        Avatar-only mode with custom dropdown menu items and enhanced guest experience using slots.
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def auth_menu">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="space-y-8">
      <.button phx-click="toggle_auth">
        Toggle Auth State
      </.button>
      <div class="flex items-center h-14">
        <.auth_menu
          class="flex items-center gap-x-6"
          id="demo-auth-menu-custom"
          avatar_only={true}
          avatar_class="w-10 h-10"
          avatar_color="bg-zinc-900 hover:bg-zinc-700"
          dropdown_position="bottom-left"
          current_user={@authenticated_user}
        >
          <:user_content>
            <.link
              navigate="/profile"
              class="block relative cursor-pointer select-none py-2 pl-3 pr-9 font-medium text-sm text-zinc-900 hover:bg-zinc-100"
            >
              <.icon name="hero-user" class="inline-block h-4 w-4 mr-2" /> Profile
            </.link>
            <.link
              navigate="/billing"
              class="block relative cursor-pointer select-none py-2 pl-3 pr-9 font-medium text-sm text-zinc-900 hover:bg-zinc-100"
            >
              <.icon name="hero-credit-card" class="inline-block h-4 w-4 mr-2" /> Billing
            </.link>
          </:user_content>
          <:guest_content>
            <div class="flex items-center space-x-3 bg-zinc-50 p-4 rounded-lg">
              <div class="w-8 h-8 bg-zinc-200 rounded-full flex items-center justify-center">
                <.icon name="hero-user" class="h-4 w-4 text-zinc-500" />
              </div>
              <div>
                <p class="text-sm font-medium text-zinc-900">
                  You're browsing as a guest
                </p>
                <p class="text-xs text-zinc-500">
                  Sign in to access all features
                </p>
              </div>
            </div>
          </:guest_content>
        </.auth_menu>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/auth_menu_custom.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
