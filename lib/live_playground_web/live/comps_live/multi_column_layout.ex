defmodule LivePlaygroundWeb.CompsLive.MultiColumnLayout do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Multi-Column Layout
      <:subtitle>
        Crafting Responsive Multi-Column Layouts in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def multi_column_layout">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <.resizable_iframe hook="IframeResize" id="multi-column-layout-demo" src="/multi-column-layout-demo" />
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/components/layouts/demo.html.heex" />
      <.code_block filename="lib/live_playground_web/live/comps_live/multi_column_layout_demo.ex" />
      <.note icon="hero-information-circle">
        Please note that this playground is itself constructed using a multi-column layout component, making it an excellent example of its usage.
        Open any page and resize the window to observe how the layout responds. Also take a look at how the layout component is implemented in the
        source code:
        <.github_link filename="lib/live_playground_web/components/layouts/recipes.html.heex">layout</.github_link>,
        <.github_link filename="lib/live_playground_web/router.ex">router</.github_link>.
      </.note>
      <.note icon="hero-information-circle">
        An interesting touch to the desktop menu is
        <.github_link filename="assets/js/hooks/preserve-scroll.js">a JavaScript hook</.github_link>
        designed to maintain the left menu's scroll position as you move between LiveViews, making navigation feel seamless.
      </.note>
    </div>
    """
  end
end
