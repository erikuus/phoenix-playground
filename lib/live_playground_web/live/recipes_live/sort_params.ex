defmodule LivePlaygroundWeb.RecipesLive.SortParams do
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
        cities: Cities.list_country_city("EST", options),
        options: options
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle-params Sorting
      <:subtitle>
        Managing Sorting With URL Parameters in LiveView
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
      <.code_block filename="lib/live_playground_web/live/recipes_live/sort_params.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# sort" to="# endsort" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp sort_link(label, col, options) do
    assigns = %{
      label: label <> get_indicator(col, options),
      to: ~p"/sort-params?#{[sort_by: col, sort_order: get_opposite(options.sort_order)]}"
    }

    ~H"""
    <.link patch={@to}>
      <%= @label %>
    </.link>
    """
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
