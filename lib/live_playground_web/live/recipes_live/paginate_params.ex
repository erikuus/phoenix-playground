defmodule LivePlaygroundWeb.RecipesLive.PaginateParams do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  @per_page 10

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, Cities.count_country_city("USA"))}
  end

  def handle_params(%{"page" => page, "per_page" => per_page}, _url, socket) do
    page = to_integer(page, 1)
    per_page = to_integer(per_page, @per_page)

    existing_page = get_existing_page(page, per_page, socket.assigns.count)
    allowed_per_page = get_allowed_per_page(per_page)

    options = %{
      page: existing_page,
      per_page: allowed_per_page
    }

    {:noreply, assign_pagination_options(socket, options)}
  end

  def handle_params(_params, _url, socket) do
    options = %{
      page: 1,
      per_page: @per_page
    }

    {:noreply, assign_pagination_options(socket, options)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle-params Pagination
      <:subtitle>
        Managing Pagination With URL Parameters in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form phx-change="update-pagination" class="flex md:flex-row-reverse md:-mt-10 md:-mb-6">
      <.input type="select" name="per_page" label="Cities per page" options={get_per_page_options()} value={@options.per_page} />
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
    <.pagination event="update-pagination" page={@options.page} per_page={@options.per_page} count_all={@count} />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/paginate_params.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# paginate" to="# endpaginate" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/paginate_params.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("update-pagination", params, socket) do
    params = update_params(params, socket.assigns.options)
    socket = push_patch(socket, to: get_pagination_url(params))
    {:noreply, socket}
  end

  defp update_params(%{"per_page" => per_page} = _params, options) do
    %{options | per_page: to_integer(per_page, @per_page)}
  end

  defp update_params(%{"page" => page} = _params, options) do
    %{options | page: to_integer(page, 1)}
  end

  defp assign_pagination_options(socket, options) do
    assign(socket,
      cities: Cities.list_country_city("USA", options),
      options: options
    )
  end

  defp get_pagination_url(params) do
    ~p"/paginate-params?#{params}"
  end

  defp get_allowed_per_page(per_page) do
    if per_page in get_per_page_options(), do: per_page, else: @per_page
  end

  defp get_per_page_options() do
    [5, 10, 20, 50, 100]
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

  defp to_integer(value, default_value) do
    case Integer.parse(value) do
      {i, _} -> i
      :error -> default_value
    end
  end
end
