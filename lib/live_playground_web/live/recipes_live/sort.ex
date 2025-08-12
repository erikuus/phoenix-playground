defmodule LivePlaygroundWeb.RecipesLive.Sort do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  @countrycode "EST"
  @permitted_sort_orders ~w(asc desc)
  @permitted_sort_by ~w(name district population)

  def mount(_params, _session, socket) do
    options = %{
      sort_order: :asc,
      sort_by: :name
    }

    {:ok, apply_sorting_options(socket, options)}
  end

  defp apply_sorting_options(socket, options) do
    assign(socket,
      cities: Cities.list_country_city(@countrycode, options),
      options: options
    )
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle-event Sorting
      <:subtitle>
        Implementing Sorting Without URL Parameters in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label={sort_link("Name", :name, @options)}>
        {city.name}
      </:col>
      <:col :let={city} label={sort_link("District", :district, @options)}>
        {city.district}
      </:col>
      <:col :let={city} label={sort_link("Population", :population, @options)}>
        {Number.Delimit.number_to_delimited(city.population,
          precision: 0,
          delimiter: " "
        )}
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/sort.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# sort" to="# endsort" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/sort.html" />
    <!-- end hiding from live code -->
    """
  end

  defp sort_link(label, col, options) do
    assigns = %{
      label: label,
      indicator: get_indicator(col, options),
      sort_order: get_next_sort_order(col, options),
      sort_by: col
    }

    ~H"""
    <.link phx-click="sort" phx-value-order={@sort_order} phx-value-by={@sort_by} class="flex gap-x-1">
      <span>{@label}</span>
      <span>{@indicator}</span>
    </.link>
    """
  end

  def handle_event("sort", %{"order" => sort_order, "by" => sort_by}, socket) do
    options = %{
      sort_order: to_permitted_atom(sort_order, @permitted_sort_orders, :asc),
      sort_by: to_permitted_atom(sort_by, @permitted_sort_by, :name)
    }

    {:noreply, apply_sorting_options(socket, options)}
  end

  defp get_indicator(col, options) when col == options.sort_by do
    case options.sort_order do
      :asc -> "↑"
      :desc -> "↓"
    end
  end

  defp get_indicator(_, _), do: ""

  defp get_next_sort_order(col, options) when col == options.sort_by do
    case options.sort_order do
      :asc -> :desc
      :desc -> :asc
    end
  end

  defp get_next_sort_order(_, _), do: :asc

  defp to_permitted_atom(str, whitelist, fallback)
       when is_binary(str) and byte_size(str) <= 20 do
    if str in whitelist, do: String.to_existing_atom(str), else: fallback
  end

  defp to_permitted_atom(_, _, fallback), do: fallback
end
