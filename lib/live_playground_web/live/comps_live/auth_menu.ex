defmodule LivePlaygroundWeb.CompsLive.AuthMenu do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :authenticated_user, nil)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Auth Menu
      <:subtitle>
        Interactive demo where mock authentication status can be toggled
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
        <.auth_menu id="demo-auth-menu" class="flex" current_user={@authenticated_user} />
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/auth_menu.ex" />
    </div>
    <!-- end hiding from live code -->
    """
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
end
