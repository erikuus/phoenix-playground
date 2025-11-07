defmodule LivePlaygroundWeb.RecipesLive.Paginate do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  @countrycode "USA"
  @per_page 10

  def mount(_params, _session, socket) do
    count = Cities.count_country_city(@countrycode)

    options = %{
      page: 1,
      per_page: @per_page
    }

    socket =
      socket
      |> assign(:count, count)
      |> apply_pagination_options(options)

    {:ok, socket}
  end

  defp apply_pagination_options(socket, options) do
    assign(socket,
      cities: Cities.list_country_city(@countrycode, options),
      options: options
    )
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
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form phx-change="change-per-page" class="flex md:flex-row-reverse md:-mt-10 md:-mb-6">
      <.input type="select" name="per_page" label="Cities per page" options={get_per_page_options()} value={@options.per_page} />
    </form>
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name">
        {city.name}
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-zinc-700">{city.district}</dd>
        </dl>
      </:col>
      <:col :let={city} label="District" class="hidden md:table-cell w-1/3">
        {city.district}
      </:col>
      <:col :let={city} label="Population" class="text-right w-1/3">
        {Number.Delimit.number_to_delimited(city.population,
          precision: 0,
          delimiter: " "
        )}
      </:col>
    </.table>
    <.pagination event="change-page" page={@options.page} per_page={@options.per_page} count_all={@count} />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/paginate.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# paginate" to="# endpaginate" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/paginate.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("change-per-page", %{"per_page" => per_page}, socket) do
    per_page =
      per_page
      |> to_integer(@per_page)
      |> get_allowed_per_page()

    page = get_existing_page(socket.assigns.options.page, per_page, socket.assigns.count)
    options = %{socket.assigns.options | per_page: per_page, page: page}

    {:noreply, apply_pagination_options(socket, options)}
  end

  def handle_event("change-page", %{"page" => page}, socket) do
    page = to_integer(page, 1)
    options = %{socket.assigns.options | page: page}
    {:noreply, apply_pagination_options(socket, options)}
  end

  defp to_integer(value, default_value) do
    case Integer.parse(value) do
      {i, _} -> i
      :error -> default_value
    end
  end

  defp get_per_page_options() do
    [5, 10, 20, 50, 100]
  end

  defp get_allowed_per_page(per_page) do
    if per_page in get_per_page_options(), do: per_page, else: @per_page
  end

  defp get_existing_page(page, per_page, count) do
    max_page = ceil_div(count, per_page)

    cond do
      page > max_page -> max_page
      page < 1 -> 1
      true -> page
    end
  end

  defp ceil_div(num, denom) do
    div(num + denom - 1, denom)
  end
end
