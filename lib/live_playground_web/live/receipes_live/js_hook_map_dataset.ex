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
    <div
      id="map"
      phx-hook="MapDataset"
      data-locations={Jason.encode!(@locations)}
      phx-update="ignore"
      class="h-64 sm:h-96 w-full rounded-md"
    >
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/js_hook_map_dataset.ex")) %>
      <%= raw(code("lib/live_playground/locations.ex", "# jshookmapdataset", "# endjshookmapdataset")) %>
      <%= raw(code("lib/live_playground/locations/location.ex", "# jshookmapdataset", "# endjshookmapdataset")) %>
      <%= raw(code("assets/js/app.js", "// jshooks", "// endjshooks", false)) %>
      <%= raw(code("assets/js/hooks/map-dataset.js")) %>
      <%= raw(code("assets/js/leaflets/map-dataset.js")) %>
      <.card class="px-4 py-5 sm:p-6">
        <div class="flex">
          <div class="flex-shrink-0">
            <.icon name="hero-information-circle" class="h-10 w-10" />
          </div>
          <div class="ml-3">
            <p class="font-semibold">Install required javascript library as follows:</p>
            <p class="font-mono">cd assets</p>
            <p class="font-mono">npm install --save leaflet@1.7.1</p>
            <p class="mt-4 font-semibold">Link stylesheet in root.html.heex as follows:</p>
            <p class="font-mono">&lt;link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.cs" /&gt;</p>
          </div>
        </div>
      </.card>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
