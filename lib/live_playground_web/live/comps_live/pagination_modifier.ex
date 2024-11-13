defmodule LivePlaygroundWeb.CompsLive.PaginationModifier do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Pagination with Tailwind CSS Modifier
      <:subtitle>
        Adding Tailwind Modifier to Define Screen Breakpoint for Displaying Page Links
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def pagination_modifier">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <.resizable_iframe hook="IframeResize" id="pagination-modifier-demo" src="/pagination-modifier-demo" />
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/pagination_modifier_demo.ex" />
    </div>
    """
  end
end
