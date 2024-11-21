defmodule LivePlaygroundWeb.RecipesLive.JsHookMapHandleEvent do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Locations

  def mount(_params, _session, socket) do
    locations = Locations.list_est_location()

    socket =
      assign(socket,
        locations: locations,
        selected: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle Events
      <:subtitle>
        Integrating a Map Library and Handling Events in JavaScript With LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <.alert class="mb-6">
      Click on a location in the list to add a marker on the map. Observe how the marker gets highlighted after being added.
    </.alert>
    <!-- end hiding from live code -->
    <div class="sm:flex">
      <div id="map-container" phx-update="ignore" class="sm:flex-auto sm:w-96">
        <div id="map" phx-hook="MapHandleEvents" class="h-64 sm:h-96 rounded-md"></div>
      </div>
      <div class="h-48 sm:h-96 mt-4 sm:flex-initial sm:w-40 sm:mt-0 sm:ml-6 overflow-auto">
        <.link
          :for={location <- @locations}
          phx-click="select-location"
          phx-value-id={location.id}
          class="text-gray-900 flex items-center px-3 py-2 mr-2 rounded-md text-sm hover:rounded-md hover:bg-gray-100"
        >
          <span class="flex-1"><%= location.name %></span>
          <.icon :if={location in @selected} name="hero-map-pin" class="text-gray-500" />
        </.link>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/js_hook_map_handle_event.ex" />
      <.code_block filename="lib/live_playground/locations.ex" from="# jshooks" to="# endjshooks" />
      <.code_block
        filename="assets/js/app.js"
        from="// Establish Phoenix Socket and LiveView configuration"
        to="// Show progress bar on live navigation and form submits"
        elixir={false}
      />
      <.code_block filename="assets/js/hooks/map-handle-events.js" />
      <.code_block filename="assets/js/leaflets/map-handle-events.js" />
      <.note icon="hero-information-circle">
        <p class="font-semibold">Install required javascript library as follows:</p>
        <p class="font-mono">cd assets</p>
        <p class="font-mono">npm install --save leaflet@1.7.1</p>
        <p class="mt-4 font-semibold">Link stylesheet in root.html.heex as follows:</p>
        <p class="font-mono">&lt;link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.cs" /&gt;</p>
      </.note>
      <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/js_hook_map_handle_event.html" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("select-location", %{"id" => id}, socket) do
    location = find_location(socket, String.to_integer(id))

    if location do
      socket =
        if location in socket.assigns.selected do
          push_event(socket, "highlight-marker", location)
        else
          socket
          |> update(:selected, &[location | &1])
          |> push_event("add-marker", location)
        end

      {:noreply, socket}
    else
      # If location is not found, do nothing.
      {:noreply, socket}
    end
  end

  defp find_location(socket, id) do
    Enum.find(socket.assigns.locations, &(&1.id == id))
  end
end
