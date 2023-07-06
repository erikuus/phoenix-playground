defmodule LivePlaygroundWeb.ReceipesLive.JsHookMapPushEvent do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Map Push Events
      <:subtitle>
        How to hook a JavaScript map library and push events into LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/js-hook-map-handle-event"}>
          See also: Map Handle Events <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    """
  end
end
