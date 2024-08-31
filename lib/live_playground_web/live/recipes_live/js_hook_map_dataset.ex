defmodule LivePlaygroundWeb.RecipesLive.JsHookMapDataset do
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
      Dataset
      <:subtitle>
        Integrating a Map Library via Dataset in LiveView
      </:subtitle>
      <:actions>
        <.code_breakdown_link />
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
      <.code_block filename="lib/live_playground_web/live/recipes_live/js_hook_map_dataset.ex" />
      <.code_block filename="lib/live_playground/locations.ex" from="# jshooks" to="# endjshooks" />
      <.code_block filename="lib/live_playground/locations/location.ex" from="# jshookmapdataset" to="# endjshookmapdataset" />
      <.code_block
        filename="assets/js/app.js"
        from="// Establish Phoenix Socket and LiveView configuration"
        to="// Show progress bar on live navigation and form submits"
        elixir={false}
      />
      <.code_block filename="assets/js/hooks/map-dataset.js" />
      <.code_block filename="assets/js/leaflets/map-dataset.js" />
      <.note icon="hero-information-circle">
        <p class="font-semibold">Install required javascript library as follows:</p>
        <p class="font-mono">cd assets</p>
        <p class="font-mono">npm install --save leaflet@1.7.1</p>
        <p class="mt-4 font-semibold">Link stylesheet in root.html.heex as follows:</p>
        <p class="font-mono">&lt;link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.cs" /&gt;</p>
      </.note>
      <.code_breakdown_slideover filename="priv/static/html/js_hook_map_dataset.html" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
