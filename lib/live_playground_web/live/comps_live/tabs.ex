defmodule LivePlaygroundWeb.CompsLive.Tabs do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Tabs
      <:subtitle>
        Organizing Content with Tabs in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def tabs">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <.resizable_iframe hook="IframeResize" id="multi-column-layout-demo" src="/tabs-demo" />
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/tabs_demo.ex" />
    </div>
    """
  end
end
