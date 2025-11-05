defmodule LivePlaygroundWeb.CompsLive.AuthMenu do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    authenticated_user = %{
      email: "john.doe@example.com",
      inserted_at: ~N[2023-06-15 10:30:00]
    }

    socket =
      socket
      |> assign(:authenticated_user, authenticated_user)
      |> assign(:show_authenticated, false)

    {:ok, socket}
  end

  def handle_event("toggle_auth", _params, socket) do
    {:noreply, assign(socket, :show_authenticated, !socket.assigns.show_authenticated)}
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
      <.auth_menu id="demo-auth-menu" class="flex" current_user={if @show_authenticated, do: @authenticated_user, else: nil} />
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/auth_menu.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
