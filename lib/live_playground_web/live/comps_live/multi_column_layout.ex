defmodule LivePlaygroundWeb.CompsLive.MultiColumnLayout do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Multi-Column Layout
      <:subtitle>
        How to create responsive multi-column layout using function component
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
        <.github_link filename="lib/live_playground_web/components/layouts/recipes.html.heex">source code</.github_link>.
      </.note>
    </div>
    """
  end
end
