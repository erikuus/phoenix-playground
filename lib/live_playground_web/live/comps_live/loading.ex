defmodule LivePlaygroundWeb.CompsLive.Loading do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :loading, false)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Loading
      <:subtitle>
        Adding Loading Indicators in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def loading">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex items-center space-x-6">
      <.loading />
      <.button phx-click="load">
        Load <.loading :if={@loading} class="ml-2 -mr-2 w-5 h-5" />
      </.button>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/loading.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("load", _, socket) do
    Process.send_after(self(), :reset, 2000)
    {:noreply, assign(socket, :loading, true)}
  end

  def handle_info(:reset, socket) do
    {:noreply, assign(socket, :loading, false)}
  end
end
