defmodule LivePlaygroundWeb.SortLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  @permitted_sort_orders ~w(asc desc)
  @permitted_sort_by ~w(name district population)

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    sort_order =
      params
      |> get_permitted("sort_order", @permitted_sort_orders)
      |> String.to_atom()

    sort_by =
      params
      |> get_permitted("sort_by", @permitted_sort_by)
      |> String.to_atom()

    options = %{
      sort_order: sort_order,
      sort_by: sort_by
    }

    socket =
      assign(socket,
        cities: Cities.list_ita_city(options),
        options: options
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Sorting
      <:subtitle>
        How to sort data within live view
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label={sort_link("Name", :name, @options)}>
        <%= city.name %>
      </:col>
      <:col :let={city} label={sort_link("District", :district, @options)}>
        <%= city.district %>
      </:col>
      <:col :let={city} label={sort_link("Population", :population, @options)} class="text-right">
        <%= Number.Delimit.number_to_delimited(city.population,
          precision: 0,
          delimiter: " "
        ) %>
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/sort_live.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# sort", "# endsort")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp sort_link(label, col, options) do
    live_patch(
      label <> get_indicator(col, options),
      to: ~p"/sort?#{[sort_by: col, sort_order: get_opposite(options.sort_order)]}"
    )
  end

  defp get_indicator(col, options) when col == options.sort_by do
    case options.sort_order do
      :asc -> "▴"
      :desc -> "▾"
    end
  end

  defp get_indicator(_, _), do: ""

  defp get_opposite(order) do
    case order do
      :asc -> :desc
      :desc -> :asc
    end
  end

  defp get_permitted(params, key, whitelist) do
    value = params[key]
    if value in whitelist, do: value, else: hd(whitelist)
  end
end
