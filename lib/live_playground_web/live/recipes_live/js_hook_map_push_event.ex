defmodule LivePlaygroundWeb.RecipesLive.JsHookMapPushEvent do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Locations

  def mount(_params, _session, socket) do
    locations = Locations.list_est_location()
    location_map = Map.new(locations, &{&1.id, &1})

    socket =
      socket
      |> assign(:location_map, location_map)
      |> assign(:locations, locations)
      |> assign(:selected, nil)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Push Events
      <:subtitle>
        Pushing JS Events to LiveView via Map Integrations
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <.alert class="mb-6">
      Click on a marker to observe the scrolling of the list of locations, and take note of how the selected location gets highlighted.
    </.alert>
    <!-- end hiding from live code -->
    <div class="sm:flex">
      <div id="map-container" phx-update="ignore" class="sm:flex-auto sm:w-96">
        <div id="map" phx-hook="MapPushEvents" class="h-64 sm:h-96 rounded-md"></div>
      </div>
      <div class="h-48 sm:h-96 mt-4 sm:flex-initial sm:w-40 sm:mt-0 sm:ml-6 overflow-auto">
        <div
          :for={location <- @locations}
          id={"location-#{location.id}"}
          class={[
            "text-gray-900 group flex items-center px-3 py-2 mr-2 rounded-md text-sm",
            location == @selected && "rounded-md bg-gray-100"
          ]}
        >
          {location.name}
        </div>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/js_hook_map_push_event.ex" />
      <.code_block filename="lib/live_playground/locations.ex" from="# jshooks" to="# endjshooks" />
      <.code_block
        filename="assets/js/app.js"
        from="// Establish Phoenix Socket and LiveView configuration"
        to="// Show progress bar on live navigation and form submits"
        elixir={false}
      />
      <.code_block filename="assets/js/hooks/map-push-events.js" />
      <.code_block filename="assets/js/leaflets/map-push-events.js" />
      <.note icon="hero-information-circle">
        <p class="font-semibold">Install required javascript library as follows:</p>
        <p class="font-mono">cd assets</p>
        <p class="font-mono">npm install --save leaflet@1.7.1</p>
        <p class="mt-4 font-semibold">Link stylesheet in root.html.heex as follows:</p>
        <p class="font-mono">&lt;link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.cs" /&gt;</p>
      </.note>
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/js_hook_map_push_event.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("get-locations", _, socket) do
    {:reply, %{locations: socket.assigns.locations}, socket}
  end

  def handle_event("marker-clicked", id, socket) do
    location = get_location_by_id(socket, id)
    {:reply, %{location: location}, assign(socket, selected: location)}
  end

  defp get_location_by_id(socket, id) do
    Map.get(socket.assigns.location_map, id)
  end
end
