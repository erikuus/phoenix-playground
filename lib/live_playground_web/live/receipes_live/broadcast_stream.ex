defmodule LivePlaygroundWeb.ReceipesLive.BroadcastStream do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    if connected?(socket), do: Cities.subscribe()

    {:ok, stream(socket, :cities, Cities.list_est_city())}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(params, socket.assigns.live_action, socket)}
  end

  defp apply_action(_params, :index, socket) do
    assign(socket,
      form: get_city_form(%City{})
    )
  end

  defp apply_action(%{"id" => id}, :edit, socket) do
    city = Cities.get_city!(id)

    assign(socket,
      city: city,
      form: get_city_form(city)
    )
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Real-Time Updates with Streams
      <:subtitle>
        How to broadcast real-time updates with streams in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/broadcast"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Real-Time Updates
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form
      :if={@live_action == :index}
      for={@form}
      phx-submit="create"
      class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0"
    >
      <.input field={@form[:name]} label="Name" class="flex-auto" />
      <.input field={@form[:district]} label="District" class="flex-auto" />
      <.input field={@form[:population]} label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="" class="md:mt-8">Save</.button>
      </div>
    </.form>
    <.form
      :if={@live_action == :edit}
      for={@form}
      phx-submit="update"
      class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0"
    >
      <.input field={@form[:name]} phx-debounce="2000" label="Name" class="flex-auto" />
      <.input field={@form[:district]} phx-debounce="2000" label="District" class="flex-auto" />
      <.input field={@form[:population]} phx-debounce="2000" label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="" class="w-full md:mt-8">Save</.button>
      </div>
      <div>
        <.button_link look="secondary" patch={~p"/broadcast-stream"} class="w-full md:mt-8">
          Cancel
        </.button_link>
      </div>
    </.form>
    <.table id="cities" rows={@streams.cities}>
      <:col :let={{_id, city}} label="Name">
        <%= city.name %>
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-zinc-700"><%= city.district %></dd>
        </dl>
      </:col>
      <:col :let={{_id, city}} label="District" class="hidden md:table-cell"><%= city.district %></:col>
      <:col :let={{_id, city}} label="Population" class="text-right md:pr-10">
        <%= Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ") %>
      </:col>
      <:action :let={{id, city}}>
        <.link patch={~p"/broadcast-stream/edit?#{[id: city.id]}"} class="md:mr-4">
          <span class="hidden md:inline">Edit</span>
          <.icon name="hero-pencil-square-mini" class="md:hidden h-6 w-6" />
        </.link>
        <.link phx-click={JS.push("delete", value: %{id: city.id}) |> hide("##{id}")} data-confirm="Are you sure?">
          <span class="hidden md:inline">Delete</span>
          <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/broadcast_stream.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# broadcaststream", "# endbroadcaststream")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("create", %{"city" => params}, socket) do
    params = Map.put(params, "countrycode", "EST")

    case Cities.create_city_broadcast(params) do
      {:ok, _city} ->
        {:noreply, assign(socket, :form, get_city_form(%City{}))}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("update", %{"city" => params}, socket) do
    case Cities.update_city_broadcast(socket.assigns.city, params) do
      {:ok, _city} ->
        {:noreply, push_patch(socket, to: ~p"/broadcast-stream")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    city = Cities.get_city!(id)
    {:ok, _} = Cities.delete_city_broadcast(city)

    {:noreply, socket}
  end

  def handle_info({:create_city, city}, socket) do
    {:noreply, stream_insert(socket, :cities, city, at: 0)}
  end

  def handle_info({:update_city, city}, socket) do
    {:noreply, stream_insert(socket, :cities, city)}
  end

  def handle_info({:delete_city, city}, socket) do
    {:noreply, stream_delete(socket, :cities, city)}
  end

  defp get_city_form(city) do
    city
    |> Cities.change_city()
    |> to_form()
  end
end
