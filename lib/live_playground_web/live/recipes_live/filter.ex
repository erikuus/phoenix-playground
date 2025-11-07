defmodule LivePlaygroundWeb.RecipesLive.Filter do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  @countrycode "USA"

  def mount(_params, _session, socket) do
    {:ok, assign_filter(socket, get_default_filter())}
  end

  defp assign_filter(socket, filter) do
    assign(socket,
      cities: Cities.list_country_city(@countrycode, filter),
      filter: filter
    )
  end

  defp get_default_filter do
    %{
      district: "",
      name: "",
      sm: "false",
      md: "false",
      lg: "false"
    }
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle-event Filtering
      <:subtitle>
        Filtering Data Without URL Parameters in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form id="filter-form" class="space-y-4 mb-6 md:flex md:items-end md:space-x-6" phx-change="filter">
      <.input type="text" name="name" label="Name" value={@filter.name} phx-debounce="500" />
      <.input type="select" name="district" label="District" options={get_district_options()} value={@filter.district} />
      <div class="md:flex md:space-x-6 md:pb-2.5">
        <.input :for={size <- get_size_options()} type="checkbox" label={size.label} name={size.name} value={@filter[size.key]} />
      </div>
    </form>
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
        {Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ")}
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/filter.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# filter" to="# endfilter" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/filter.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event(
        "filter",
        %{"name" => name, "district" => district, "sm" => sm, "md" => md, "lg" => lg},
        socket
      ) do
    filter = %{
      district: district,
      name: name,
      sm: sm,
      md: md,
      lg: lg
    }

    if filter != socket.assigns.filter do
      {:noreply, assign_filter(socket, filter)}
    else
      {:noreply, socket}
    end
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
end
