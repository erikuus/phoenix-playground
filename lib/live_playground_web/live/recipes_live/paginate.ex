defmodule LivePlaygroundWeb.RecipesLive.Paginate do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    count = Cities.count_country_city("USA")

    options = %{
      page: 1,
      per_page: 10
    }

    socket =
      socket
      |> assign(:count, count)
      |> assign_pagination_options(options)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle-event Pagination
      <:subtitle>
        Implementing Pagination Without URL Parameters in LiveView
      </:subtitle>
      <:actions>
        <.code_breakdown_link />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form phx-change="select-per-page" class="flex md:flex-row-reverse md:-mt-10 md:-mb-6">
      <.input type="select" name="per_page" label="Cities per page" options={[5, 10, 20, 50, 100]} value={@options.per_page} />
    </form>
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name">
        <%= city.name %>
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-gray-700"><%= city.district %></dd>
        </dl>
      </:col>
      <:col :let={city} label="District" class="hidden md:table-cell w-1/3">
        <%= city.district %>
      </:col>
      <:col :let={city} label="Population" class="text-right w-1/3">
        <%= Number.Delimit.number_to_delimited(city.population,
          precision: 0,
          delimiter: " "
        ) %>
      </:col>
    </.table>
    <.pagination event="select-page" page={@options.page} per_page={@options.per_page} count_all={@count} />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/paginate.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# paginate" to="# endpaginate" />
    </div>
    <.code_breakdown_slideover filename="priv/static/html/paginate.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("select-per-page", %{"per_page" => per_page}, socket) do
    per_page = String.to_integer(per_page)
    page = get_existing_page(socket.assigns.options.page, per_page, socket.assigns.count)
    options = %{socket.assigns.options | per_page: per_page, page: page}

    {:noreply, assign_pagination_options(socket, options)}
  end

  def handle_event("select-page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    options = %{socket.assigns.options | page: page}
    {:noreply, assign_pagination_options(socket, options)}
  end

  defp assign_pagination_options(socket, options) do
    assign(socket,
      cities: Cities.list_country_city("USA", options),
      options: options
    )
  end

  # Ensures users aren't left on an invalid page when changing the number of items per page
  defp get_existing_page(page, per_page, count) do
    max_page = ceil_div(count, per_page)

    cond do
      page > max_page -> max_page
      page < 1 -> 1
      true -> page
    end
  end

  # Performs ceiling division on two integers.
  # It calculates how many complete or partial units of `denom` fit into `num` and rounds up if there is any remainder.
  # This method is particularly useful for scenarios like pagination where you need to determine the number of pages.
  # This approach avoids floating-point operations by adding `denom - 1` to `num` before dividing.
  # This addition ensures that any remainder in the division results in rounding up the quotient to the next integer.
  #
  # Example:
  #   ceil_div(45, 10) returns 5, calculating 5 pages needed to display 45 items with 10 items per page.
  #
  # This function is preferred over floating-point ceil(num / denom) to avoid potential precision issues and to maintain
  # integer arithmetic for efficiency and accuracy, especially important in environments where consistency of data types is crucial.
  defp ceil_div(num, denom) do
    div(num + denom - 1, denom)
  end
end
