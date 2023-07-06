defmodule LivePlaygroundWeb.ReceipesLive.JsHookMapDataset do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Locations

  def mount(_params, _session, socket) do
    socket = assign(socket, :locations, Locations.list_est_location())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Map Dataset
      <:subtitle>
        How to hook a JavaScript map library and add markers with dataset in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/js-hook-map-push-event"}>
          See also: Map Push Events <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div id="map" phx-hook="MapDataset" data-locations={Jason.encode!(@locations)} phx-update="ignore" class="w-full h-96 rounded-md">
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/js_hook_map_dataset.ex")) %>
      <%= raw(code("lib/live_playground/locations.ex", "# jshookmapdataset", "# endjshookmapdataset")) %>
      <%= raw(code("lib/live_playground/locations/location.ex", "# jshookmapdataset", "# endjshookmapdataset")) %>
      <%= raw(code("assets/js/app.js", "// jshookmapdataset", "// endjshookmapdataset", false)) %>
      <%= raw(code("assets/js/map-dataset.js")) %>
      <%= raw(code("assets/js/map.js")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
