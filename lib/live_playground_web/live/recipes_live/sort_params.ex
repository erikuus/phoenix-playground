defmodule LivePlaygroundWeb.RecipesLive.SortParams do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  # Sort configuration
  @permitted_sort_orders ~w(asc desc)
  @permitted_sort_by ~w(name district population)
  @default_sort_options %{sort_order: :asc, sort_by: :name}

  # Data configuration
  @countrycode "EST"
  @max_param_length 20

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"sort_order" => sort_order, "sort_by" => sort_by}, _url, socket) do
    options = %{
      sort_order:
        to_permitted_atom(sort_order, @permitted_sort_orders, @default_sort_options.sort_order),
      sort_by: to_permitted_atom(sort_by, @permitted_sort_by, @default_sort_options.sort_by)
    }

    {:noreply, apply_sorting_options(socket, options)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, apply_sorting_options(socket, @default_sort_options)}
  end

  defp to_permitted_atom(str, whitelist, fallback)
       when is_binary(str) and byte_size(str) <= @max_param_length do
    if str in whitelist, do: String.to_existing_atom(str), else: fallback
  end

  defp to_permitted_atom(_, _, fallback), do: fallback

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
      Handle-params Sorting
      <:subtitle>
        Managing Sorting With URL Parameters in LiveView
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
      <.code_block filename="lib/live_playground_web/live/recipes_live/sort_params.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# sort" to="# endsort" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/sort_params.html" />
    <!-- end hiding from live code -->
    """
  end

  defp sort_link(label, col, options) do
    assigns = %{
      label: label,
      indicator: get_indicator(col, options),
      to: ~p"/sort-params?#{[sort_by: col, sort_order: get_next_sort_order(col, options)]}"
    }

    ~H"""
    <.link patch={@to} class="flex gap-x-1">
      <span>{@label}</span>
      <span>{@indicator}</span>
    </.link>
    """
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
end
