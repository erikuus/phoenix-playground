defmodule LivePlaygroundWeb.CompsLive.NarrowSidebar do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Narrow Sidebar
      <:subtitle>
        How to use Narrow Sidebar component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def narrow_sidebar">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <.resizable_iframe hook="IframeResize" id="multi-column-layout-demo" src="/narrow-sidebar-demo" />
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/narrow_sidebar_demo.ex" />
      <.note icon="hero-information-circle">
        It could prove beneficial for you to explore the implementation of the sidebar component within this playground.
        The sidebar is encapsulated within the
        <.github_link filename="lib/live_playground_web/components/menus/sidebar.ex">menu component</.github_link>,
        which features an 'active layout' attribute configured in various
        <.github_link filename="lib/live_playground_web/components/layouts/recipes.html.heex">layouts</.github_link>.
        The active sidebar item is determined within the menu component based on the value of the active layout attribute.
      </.note>
    </div>
    """
  end
end
