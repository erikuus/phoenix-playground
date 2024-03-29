defmodule LivePlaygroundWeb.RecipesLive.JsCommandsReal do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    count = Cities.count_country_city("USA")

    options = %{
      page: 1,
      per_page: 10
    }

    socket =
      socket
      |> assign(count: count, selected_cities: [])
      |> assign_pagination_options(options)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Real World Example of JS Commands
      <:subtitle>
        How to use javascript commands to enhance your table in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/js-commands"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: JS Commands
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name">
        <%= city.name %>
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-gray-700"><%= city.district %></dd>
        </dl>
      </:col>
      <:col :let={city} label="District" class="hidden md:table-cell w-1/3">
        <%= city.district %>
      </:col>
      <:col :let={city} label="Population" class="text-right w-1/3">
        <%= Number.Delimit.number_to_delimited(city.population,
          precision: 0,
          delimiter: " "
        ) %>
      </:col>
      <:action :let={city}>
        <.link :if={city in @selected_cities} phx-click={JS.push("unselect", value: %{id: city.id})}>
          <span class="hidden md:inline">Remove</span>
          <.icon name="hero-check-circle" class="md:hidden" />
        </.link>
        <.link :if={city not in @selected_cities} phx-click={JS.push("select", value: %{id: city.id})}>
          <span class="hidden md:inline">Select</span>
          <.icon name="hero-check-circle text-zinc-300" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <.pagination event="select-page" page={@options.page} per_page={@options.per_page} count_all={@count} />
    <.simple_list :if={@selected_cities != []} class="text-sm">
      <:item :for={selected_city <- @selected_cities} class="flex justify-between items-center">
        <span><%= selected_city.name %></span>
        <.link phx-click={JS.push("remove", value: %{id: selected_city.id})}>
          <span class="hidden md:inline md:font-semibold">Remove</span>
          <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:item>
    </.simple_list>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/js_commands_grid.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# jscommands" to="# endjscommands" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("select", %{"id" => id}, socket) do
    city = Cities.get_city!(id)
    {:noreply, update(socket, :selected_cities, &[city | &1])}
  end

  def handle_event("remove", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("select-page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    options = %{socket.assigns.options | page: page}
    {:noreply, assign_pagination_options(socket, options)}
  end

  defp assign_pagination_options(socket, options) do
    assign(socket,
      cities: Cities.list_country_city("USA", options),
      options: options
    )
  end
end
