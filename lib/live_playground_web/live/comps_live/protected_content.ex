defmodule LivePlaygroundWeb.CompsLive.ProtectedContent do
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

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Protected Content
      <:subtitle>
        Protecting Content Behind Authentication in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def protected_content">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="space-y-8">
      <.button phx-click="toggle_auth">
        Toggle Auth State
      </.button>
      <.protected_content current_user={if @show_authenticated, do: @authenticated_user, else: nil}>
        <div class="bg-green-50 border border-green-200 rounded-lg p-6">
          <p class="text-sm text-green-700">
            You can see this content because you are authenticated.
            This could be premium features, user-specific data, or any protected resource.
          </p>
        </div>
      </.protected_content>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/protected_content.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("toggle_auth", _params, socket) do
    {:noreply, assign(socket, :show_authenticated, !socket.assigns.show_authenticated)}
  end
end
