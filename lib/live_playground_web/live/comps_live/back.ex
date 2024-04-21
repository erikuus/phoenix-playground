defmodule LivePlaygroundWeb.CompsLive.Back do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Back
      <:subtitle>
        Adding a Simple "Go Back" Link in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def back">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.back navigate={~p"/icon"}>Back to Icon</.back>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/back.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
