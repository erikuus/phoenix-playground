defmodule LivePlaygroundWeb.RecipesLive.StreamInsert do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:cities, Cities.list_est_city())
      |> assign(:form, get_empty_form())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Stream Insert
      <:subtitle>
        How to insert items into large collections without keeping them in memory on the server
      </:subtitle>
      <:actions>
        <.link navigate={~p"/stream-update"}>
          See also: Stream Update <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-submit="save" class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0">
      <.input field={@form[:name]} label="Name" class="flex-auto" />
      <.input field={@form[:district]} label="District" class="flex-auto" />
      <.input field={@form[:population]} label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="" class="md:mt-8">Save</.button>
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
        <.link phx-click={JS.push("delete", value: %{id: city.id}) |> hide("##{id}")} data-confirm="Are you sure?">
          <span class="hidden md:inline">Delete</span>
          <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/recipes_live/stream_insert.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# streaminsert", "# endstreaminsert")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("save", %{"city" => params}, socket) do
    params = Map.put(params, "countrycode", "EST")

    case Cities.create_city(params) do
      {:ok, city} ->
        socket = stream_insert(socket, :cities, city, at: 0)
        socket = assign(socket, :form, get_empty_form())

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    city = Cities.get_city!(id)
    {:ok, _} = Cities.delete_city(city)

    {:noreply, stream_delete(socket, :cities, city)}
  end

  defp get_empty_form() do
    %City{}
    |> Cities.change_city()
    |> to_form()
  end
end
