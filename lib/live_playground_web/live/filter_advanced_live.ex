defmodule LivePlaygroundWeb.FilterAdvancedLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"n" => name, "d" => district, "s" => sizes}, _url, socket) do
    filter = %{
      district: district,
      name: name,
      sizes: String.split(sizes, "-")
    }

    {:noreply, assign_filter(socket, filter)}
  end

  def handle_params(_params, _url, socket) do
    filter = %{
      district: "",
      name: "",
      sizes: [""]
    }

    {:noreply, assign_filter(socket, filter)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Advanced Filter
      <:subtitle>
        How to filter data in live view with url parameters
      </:subtitle>
      <:actions>
        <.link navigate={~p"/filter"}>
          Back to simple filter
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form id="filter-form" class="lg:flex lg:items-end lg:space-x-6 space-y-4 mb-6" phx-change="filter">
      <.input type="text" id="name" name="name" label="Name" value={@filter.name} phx-debounce="500" />
      <.input type="select" id="district" name="district" label="District" options={districts()} value={@filter.district} />
      <div class="lg:flex lg:space-x-6 lg:pb-2.5">
        <.input :for={size <- sizes()} type="checkbox" name="sizes[]" value={size} id={size} label={size} />
      </div>
      <input type="hidden" name="sizes[]" value="" />
    </form>
    <UiComponent.alert :if={@cities == []}>
      No results
    </UiComponent.alert>
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name"><%= city.name %></:col>
      <:col :let={city} label="District"><%= city.district %></:col>
      <:col :let={city} label="Population" class="text-right">
        <div class="text-right">
          <%= Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ") %>
        </div>
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/filter_advanced_live.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# filter", "# endfilter")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("filter", %{"name" => name, "district" => district, "sizes" => sizes}, socket) do
    sizes =
      sizes
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("-")

    socket =
      push_patch(socket,
        to: ~p"/filter-advanced?#{[d: district, n: name, s: sizes]}"
      )

    {:noreply, socket}
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
