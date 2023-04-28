defmodule LivePlaygroundWeb.FilterParamsLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(
        %{"name" => name, "dist" => dist, "sm" => sm, "md" => md, "lg" => lg},
        _url,
        socket
      ) do
    filter = %{
      dist: dist,
      name: name,
      sm: sm,
      md: md,
      lg: lg
    }

    {:noreply, assign_filter(socket, filter)}
  end

  def handle_params(_params, _url, socket) do
    filter = %{
      dist: "",
      name: "",
      sm: "false",
      md: "false",
      lg: "false"
    }

    {:noreply, assign_filter(socket, filter)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Filter with URL Parameters
      <:subtitle>
        How to handle filter parameters in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/filter"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Filter
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form id="filter-form" class="md:flex md:items-end md:space-x-6 space-y-4 mb-6" phx-change="filter">
      <.input type="text" name="name" label="Name" value={@filter.name} phx-debounce="500" />
      <.input type="select" name="dist" label="District" options={dist_options()} value={@filter.dist} />
      <div class="md:flex md:space-x-6 md:pb-2.5">
        <.input :for={size <- size_options()} type="checkbox" label={size.label} name={size.name} value={@filter[size.key]} />
      </div>
    </form>
    <.alert :if={@cities == []}>
      No results
    </.alert>
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name">
        <%= city.name %>
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-gray-700"><%= city.district %></dd>
        </dl>
      </:col>
      <:col :let={city} label="District" class="hidden md:table-cell"><%= city.district %></:col>
      <:col :let={city} label="Population" class="text-right">
        <%= Number.Delimit.number_to_delimited(city.population,
          precision: 0,
          delimiter: " "
        ) %>
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/filter_params_live.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# filter", "# endfilter")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event(
        "filter",
        %{"name" => name, "dist" => dist, "sm" => sm, "md" => md, "lg" => lg},
        socket
      ) do
    socket =
      push_patch(socket,
        to: ~p"/filter-params?#{[name: name, dist: dist, sm: sm, md: md, lg: lg]}"
      )

    {:noreply, socket}
  end

  defp assign_filter(socket, filter) do
    assign(socket,
      cities: Cities.list_usa_city(filter),
      filter: filter
    )
  end

  defp dist_options() do
    districts =
      Cities.list_distinct_usa_district()
      |> Enum.map(fn x -> x.district end)

    ["" | districts]
  end

  defp size_options() do
    [
      %{key: :sm, name: "sm", label: "Small"},
      %{key: :md, name: "md", label: "Medium"},
      %{key: :lg, name: "lg", label: "Large"}
    ]
  end
end