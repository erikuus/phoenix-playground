defmodule LivePlaygroundWeb.FilterLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    filter = %{
      district: "",
      name: "",
      sizes: [""]
    }

    {:ok, assign_filter(socket, filter)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.heading>
      Filter
      <:footer>
      How to filter data in live view
      </:footer>
      <:buttons>
        <.button href="/filter-advanced" color={:secondary}>
          Try advanced filter
        </.button>
      </:buttons>
    </.heading>
    <!-- end hiding from live code -->
    <form id="filter-form" class="lg:flex lg:items-end lg:space-x-6 space-y-4 mb-6" phx-change="filter">
      <div class="flex-1">
        <.input type="text" id="name" name="name" label="Name" value={@filter.name} phx-debounce="500" />
      </div>
      <div class="flex-1">
        <.select id="district" name="district" label="District">
          <%= options_for_select(districts(), @filter.district) %>
        </.select>
      </div>
      <div class="flex-1">
        <div class="lg:flex lg:space-x-6">
          <.checkbox :for={size <- sizes()} checked={size in @filter.sizes} name="sizes[]" value={size} id={size} label={size}/>
          <input type="hidden" name="sizes[]" value="" />
        </div>
      </div>
    </form>
    <.alert :if={@cities == []}>
      No results
    </.alert>
    <.table :if={@cities != []}>
      <thead>
        <tr>
          <.th>Name</.th>
          <.th>District</.th>
          <.th class="text-right">Population</.th>
        </tr>
      </thead>
      <.tbody>
        <tr :for={city <- @cities}>
          <.td class="w-1/3">
            <%= city.name %>
          </.td>
          <.td class="w-1/3">
            <%= city.district %>
          </.td>
          <.td class="w-1/3 text-right">
            <%= Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ")  %>
          </.td>
        </tr>
      </.tbody>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/filter_live.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# filter", "# endfilter")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("filter", %{"name" => name, "district" => district, "sizes" => sizes}, socket) do
    filter = %{
      district: district,
      name: name,
      sizes: sizes
    }

    {:noreply, assign_filter(socket, filter)}
  end

  defp assign_filter(socket, filter) do
    assign(socket,
      cities: Cities.list_usa_city(filter),
      filter: filter
    )
  end

  defp districts() do
    ["" | Cities.list_distinct_usa_district() |> Enum.map(fn x -> x.district end)]
  end

  defp sizes() do
    ["Small", "Medium", "Large"]
  end
end
