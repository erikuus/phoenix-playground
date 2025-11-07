defmodule LivePlaygroundWeb.CompsLive.AuthMenuAdvanced do
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
      Auth Menu Advanced
      <:subtitle>
        Guest buttons in header, authenticated menu in sidebar, demonstrating flexible placement.
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
      <div class="border border-zinc-200 rounded-lg">
        <div class="border-b border-zinc-200 px-6 py-4">
          <div class="flex items-center justify-between h-14">
            <h2 class="text-lg font-semibold text-zinc-900">Page Header</h2>
            <.auth_menu :if={!@authenticated_user} id="demo-auth-menu-header" class="flex" current_user={@authenticated_user} />
          </div>
        </div>
        <div class="flex h-80">
          <div class="border-r border-zinc-200 flex flex-col justify-between p-6">
            <div>
              <h3 class="text-sm font-semibold text-zinc-900 text-center">Sidebar</h3>
            </div>
            <.auth_menu
              :if={@authenticated_user}
              id="demo-auth-menu-sidebar"
              class="flex justify-center"
              avatar_only={true}
              avatar_class="w-12 h-12"
              avatar_color="bg-zinc-900 hover:bg-zinc-700"
              dropdown_position="top-left"
              current_user={@authenticated_user}
            />
          </div>
          <div class="flex-1 p-6">
            <p class="text-sm text-zinc-600">
              Main content area
            </p>
          </div>
        </div>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/auth_menu_advanced.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
