defmodule LivePlaygroundWeb.ReceipesLive.JsCommandsReal do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    count = Cities.count_city()

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
    <.pagination>
      <:prev>
        <.page_link :if={@options.page > 1} type="prev" event="select-page" page={@options.page - 1}>
          <.icon name="hero-arrow-long-left" class="mr-3 h-5 w-5 text-gray-400" /> Previous
        </.page_link>
      </:prev>
      <:pages>
        <.page_link
          :for={page <- get_pages(@options.page, @options.per_page, @count)}
          event="select-page"
          page={page}
          active={@options.page == page}
        >
          <%= page %>
        </.page_link>
      </:pages>
      <:next>
        <.page_link :if={@options.page * @options.per_page < @count} type="next" event="select-page" page={@options.page + 1}>
          Next <.icon name="hero-arrow-long-right" class="ml-3 h-5 w-5 text-gray-400" />
        </.page_link>
      </:next>
    </.pagination>
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
      <%= raw(code("lib/live_playground_web/live/receipes_live/js_commands_grid.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# jscommands", "# endjscommands")) %>
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
      cities: Cities.list_city(options),
      options: options
    )
  end

  defp get_pages(page, per_page, count) do
    page_count = ceil(count / per_page)

    for page_number <- (page - 5)..(page + 5),
        page_number > 0 and page_number <= page_count do
      page_number
    end
  end
end
