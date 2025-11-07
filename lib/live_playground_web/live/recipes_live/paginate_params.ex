defmodule LivePlaygroundWeb.RecipesLive.PaginateParams do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  @countrycode "USA"
  @per_page 10

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count_all, Cities.count_country_city(@countrycode))}
  end

  def handle_params(params, _url, socket) do
    options = convert_params(%{}, params)
    valid_options = validate_options(socket, options)

    if options != valid_options do
      {:noreply, push_navigate(socket, to: get_pagination_url(valid_options))}
    else
      {:noreply, apply_pagination_options(socket, valid_options)}
    end
  end

  defp convert_params(options, %{"page" => page, "per_page" => per_page} = _params) do
    page = to_integer(page, 0)
    per_page = to_integer(per_page, 0)
    Map.merge(options, %{page: page, per_page: per_page})
  end

  defp convert_params(options, %{"page" => page} = _params) do
    page = to_integer(page, 0)
    per_page = 0
    Map.merge(options, %{page: page, per_page: per_page})
  end

  defp convert_params(options, %{"per_page" => per_page} = _params) do
    page = 0
    per_page = to_integer(per_page, 0)
    Map.merge(options, %{page: page, per_page: per_page})
  end

  defp convert_params(options, _params) do
    Map.merge(options, %{page: 0, per_page: 0})
  end

  defp to_integer(value, _default_value) when is_integer(value), do: value

  defp to_integer(value, default_value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} when i > 0 -> i
      _ -> default_value
    end
  end

  defp to_integer(_value, default_value), do: default_value

  defp validate_options(socket, options) do
    existing_page = get_existing_page(options.page, options.per_page, socket.assigns.count_all)
    allowed_per_page = get_allowed_per_page(options.per_page)

    Map.merge(options, %{page: existing_page, per_page: allowed_per_page})
  end

  defp get_existing_page(page, per_page, count_all) do
    # Use max/2 to ensure per_page is at least 1 to avoid division by zero
    safe_per_page = max(per_page, 1)
    max_page = ceil_div(count_all, safe_per_page)

    cond do
      # When there are no items, stay on page 1
      max_page == 0 -> 1
      page > max_page -> max_page
      page < 1 -> 1
      true -> page
    end
  end

  defp ceil_div(_num, 0), do: 0
  defp ceil_div(num, denom), do: div(num + denom - 1, denom)

  defp get_allowed_per_page(per_page) do
    if per_page in get_per_page_options(), do: per_page, else: @per_page
  end

  defp get_per_page_options() do
    [5, 10, 20, 50, 100]
  end

  defp get_pagination_url(params) do
    ~p"/paginate-params?#{params}"
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
      Handle-params Pagination
      <:subtitle>
        Managing Pagination With URL Parameters in LiveView
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
    <.pagination
      patch_path="/paginate-params"
      page={@options.page}
      per_page={@options.per_page}
      count_all={@count_all}
      params_per_page_key="per_page"
      hook="ScrollToTop"
    />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/paginate_params.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# paginate" to="# endpaginate" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/paginate_params.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("change-per-page", params, socket) do
    per_page = to_integer(params["per_page"], @per_page)
    options = %{socket.assigns.options | per_page: per_page}
    socket = push_patch(socket, to: get_pagination_url(options))
    {:noreply, socket}
  end
end
