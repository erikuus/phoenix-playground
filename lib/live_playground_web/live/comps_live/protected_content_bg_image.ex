defmodule LivePlaygroundWeb.CompsLive.ProtectedContentBgImage do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  def mount(_params, _session, socket) do
    languages = Languages.list_languages_by_countries(["EST"])

    socket =
      socket
      |> assign(:show_authenticated, false)
      |> assign(:languages, languages)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Protected Content with Background Image
      <:subtitle>
        Using Background Image and Footer Slot
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
      <.protected_content
        current_user={if @show_authenticated, do: %{email: "user@example.com"}, else: nil}
        background_image="/images/DSC04195.jpg"
        message="This demo is available to authenticated users only."
      >
        <:footer>
          <div class="mt-6 pt-6 border-t border-zinc-400">
            <p class="text-xs text-zinc-600">
              Explore Mediterranean destinations.
              <a href="#" class="text-zinc-900 font-medium hover:underline">
                Browse Greece travel guide
              </a>
            </p>
          </div>
        </:footer>
        <img src="/images/DSC04195.jpg" class="w-full rounded-lg" />
      </.protected_content>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/protected_content_bg_image.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("toggle_auth", _params, socket) do
    {:noreply, assign(socket, :show_authenticated, !socket.assigns.show_authenticated)}
  end
end
