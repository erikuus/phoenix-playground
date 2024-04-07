defmodule LivePlaygroundWeb.CompsLive.Icon do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Icon
      <:subtitle>
        Incorporating Icons in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def icon">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.icon name="hero-cake" />
    <.icon name="hero-cake-solid" />
    <.icon name="hero-cake-mini" />
    <.icon name="hero-cake" class="bg-red-500 w-10 h-10" />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/icon.ex" />
      <.note icon="hero-information-circle">
        Heroicons are beautiful hand-crafted SVG icons, by the makers of Tailwind CSS.
        Explore the entire collection <.link target="blank" class="underline" href="https://heroicons.com/">here</.link>.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
