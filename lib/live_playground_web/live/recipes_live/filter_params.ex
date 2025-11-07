defmodule LivePlaygroundWeb.RecipesLive.FilterParams do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  @countrycode "USA"

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    filter = get_filter_from_params(params)

    socket =
      if params_need_normalization?(params, filter) do
        push_patch(socket, to: ~p"/filter-params?#{filter}")
      else
        socket
      end

    {:noreply, assign_filter(socket, filter)}
  end

  defp get_filter_from_params(%{
         "name" => name,
         "district" => district,
         "sm" => sm,
         "md" => md,
         "lg" => lg
       }) do
    %{
      district: district,
      name: name,
      sm: normalize_checkbox_value(sm),
      md: normalize_checkbox_value(md),
      lg: normalize_checkbox_value(lg)
    }
  end

  defp get_filter_from_params(_params), do: get_default_filter()

  defp normalize_checkbox_value("true"), do: "true"

  defp normalize_checkbox_value(_), do: "false"

  defp get_default_filter do
    %{
      district: "",
      name: "",
      sm: "false",
      md: "false",
      lg: "false"
    }
  end

  defp params_need_normalization?(%{} = params, filter) when map_size(params) > 0 do
    Map.get(params, "sm") != filter.sm or
      Map.get(params, "md") != filter.md or
      Map.get(params, "lg") != filter.lg
  end

  defp params_need_normalization?(_params, _filter), do: false

  defp assign_filter(socket, filter) do
    assign(socket,
      cities: Cities.list_country_city(@countrycode, filter),
      filter: filter
    )
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle-params Filtering
      <:subtitle>
        Handling Filter With URL Parameters in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form id="filter-form" class="md:flex md:items-end md:space-x-6 space-y-4 mb-6" phx-change="filter">
      <.input type="text" name="name" label="Name" value={@filter.name} phx-debounce="500" />
      <.input type="select" name="district" label="District" options={get_district_options()} value={@filter.district} />
      <div class="md:flex md:space-x-6 md:pb-2.5">
        <.input :for={size <- get_size_options()} type="checkbox" label={size.label} name={size.name} value={@filter[size.key]} />
      </div>
    </form>
    <.alert :if={no_filters_applied?(@filter)}>
      Showing all records—no filters applied.
    </.alert>
    <.alert :if={@cities == []}>
      No results
    </.alert>
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name">
        {city.name}
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-zinc-700">{city.district}</dd>
        </dl>
      </:col>
      <:col :let={city} label="District" class="hidden md:table-cell">{city.district}</:col>
      <:col :let={city} label="Population" class="text-right">
        {Number.Delimit.number_to_delimited(city.population,
          precision: 0,
          delimiter: " "
        )}
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/filter_params.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# filter" to="# endfilter" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/filter_params.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("filter", params, socket) do
    filter = get_filter_from_params(params)

    socket = push_patch(socket, to: ~p"/filter-params?#{filter}")

    {:noreply, socket}
  end

  defp get_district_options() do
    ["" | Cities.list_distinct_country_districts(@countrycode)]
  end

  defp get_size_options do
    [
      %{key: :sm, name: "sm", label: "Small (≤ 500K)"},
      %{key: :md, name: "md", label: "Medium (500K - 1M)"},
      %{key: :lg, name: "lg", label: "Large (≥ 1M)"}
    ]
  end

  defp no_filters_applied?(filter) do
    filter == get_default_filter()
  end
end
