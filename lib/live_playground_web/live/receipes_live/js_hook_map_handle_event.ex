defmodule LivePlaygroundWeb.ReceipesLive.JsHookMapHandleEvent do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Map Handle Events
      <:subtitle>
        How to hook a JavaScript map library and handle events from LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/js-hook-map-dataset"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Map Dataset
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    """
  end
end
