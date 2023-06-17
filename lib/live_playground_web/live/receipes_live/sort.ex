defmodule LivePlaygroundWeb.ReceipesLive.Sort do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    options = %{
      sort_order: :asc,
      sort_by: :name
    }

    {:ok, assign_sorting_options(socket, options)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Sorting
      <:subtitle>
        How to sort data in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/sort-params"}>
          See also: Sorting with URL Parameters <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
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
      <%= raw(code("lib/live_playground_web/live/receipes_live/sort.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# sort", "# endsort")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp sort_link(label, col, options) do
    assigns = %{
      label: label <> get_indicator(col, options),
      sort_order: get_opposite(options.sort_order),
      sort_by: col
    }

    ~H"""
    <.link phx-click="sort" phx-value-order={@sort_order} phx-value-by={@sort_by}>
      <%= @label %>
    </.link>
    """
  end

  def handle_event("sort", %{"order" => sort_order, "by" => sort_by}, socket) do
    options = %{
      sort_order: String.to_atom(sort_order),
      sort_by: String.to_atom(sort_by)
    }

    {:noreply, assign_sorting_options(socket, options)}
  end

  defp assign_sorting_options(socket, options) do
    assign(socket,
      cities: Cities.list_est_city(options),
      options: options
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
end
