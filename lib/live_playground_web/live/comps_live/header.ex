defmodule LivePlaygroundWeb.CompsLive.Header do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Header
      <:subtitle>
        Implementing Headers in LiveView
      </:subtitle>

      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def header">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <.resizable_iframe hook="IframeResize" id="header-demo" src="/header-demo" />
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/header_demo.ex" />
    </div>
    """
  end
end
