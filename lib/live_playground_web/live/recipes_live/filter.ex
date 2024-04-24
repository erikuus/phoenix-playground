defmodule LivePlaygroundWeb.RecipesLive.Filter do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    filter = %{
      district: "",
      name: "",
      sm: "false",
      md: "false",
      lg: "false"
    }

    {:ok, assign_filter(socket, filter)}
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
        <.code_breakdown_link />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form id="filter-form" class="space-y-4 mb-6 md:flex md:items-end md:space-x-6" phx-change="filter">
      <.input type="text" name="name" label="Name" value={@filter.name} phx-debounce="500" />
      <.input type="select" name="district" label="District" options={district_options()} value={@filter.district} />
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
        <%= Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ") %>
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/filter.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# filter" to="# endfilter" />
    </div>
    <.code_breakdown_slideover filename="priv/static/html/filter.html" />
    <!-- end hiding from live code -->
    """
  end

  @doc """
  Handles the 'filter' event for the name textbox, district select, and size checkboxes. The values for 'sm', 'md', and 'lg'
  are guaranteed to be strings "true" or "false". This consistent behavior is ensured by the checkbox component design, which
  always returns "true" if checked and "false" if not, thanks to the combination of a hidden input and a checkbox input with
  pre-defined values.
  """
  def handle_event(
        "filter",
        %{"name" => name, "district" => district, "sm" => sm, "md" => md, "lg" => lg},
        socket
      ) do
    new_filter = %{
      district: district,
      name: name,
      sm: sm,
      md: md,
      lg: lg
    }

    if new_filter != socket.assigns.filter do
      {:noreply, assign_filter(socket, new_filter)}
    else
      {:noreply, socket}
    end
  end

  defp assign_filter(socket, filter) do
    assign(socket,
      cities: Cities.list_country_city("USA", filter),
      filter: filter
    )
  end

  defp district_options() do
    ["" | Cities.list_distinct_country_district("USA") |> Enum.map(& &1.district)]
  end

  # Provides options for size-related checkboxes. Each option includes a `key` corresponding to an atom used
  # in the `@filter` assigns. The `key` is essential for ensuring that checkbox states (checked or unchecked)
  # are accurately maintained across LiveView re-renders.
  defp size_options() do
    [
      %{key: :sm, name: "sm", label: "Small"},
      %{key: :md, name: "md", label: "Medium"},
      %{key: :lg, name: "lg", label: "Large"}
    ]
  end
end
