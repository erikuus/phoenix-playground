defmodule LivePlaygroundWeb.ReceipesLive.PaginateParams do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, Cities.count_city())}
  end

  def handle_params(params, _url, socket) do
    page = params["page"] |> to_integer(1)
    per_page = params["per_page"] |> to_integer(10)

    page = get_safe_page(page, per_page, socket.assigns.count)

    options = %{
      page: page,
      per_page: per_page
    }

    socket =
      assign(socket,
        cities: Cities.list_city(options),
        options: options
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Pagination with URL Parameters
      <:subtitle>
        How to handle pagination parameters in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/paginate"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Pagination
        </.link>
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
    <.pagination>
      <:prev>
        <.page_link :if={@options.page > 1} type="prev" patch={get_page_patch(@options.page - 1, @options)}>
          <.icon name="hero-arrow-long-left" class="mr-3 h-5 w-5 text-gray-400" /> Previous
        </.page_link>
      </:prev>
      <:pages>
        <.page_link
          :for={page <- get_pages(@options.page, @options.per_page, @count)}
          patch={get_page_patch(page, @options)}
          active={@options.page == page}
        >
          <%= page %>
        </.page_link>
      </:pages>
      <:next>
        <.page_link :if={@options.page * @options.per_page < @count} type="next" patch={get_page_patch(@options.page + 1, @options)}>
          Next <.icon name="hero-arrow-long-right" class="ml-3 h-5 w-5 text-gray-400" />
        </.page_link>
      </:next>
    </.pagination>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/paginate_params.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# paginate", "# endpaginate")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("select-per-page", %{"per_page" => per_page}, socket) do
    params = %{socket.assigns.options | per_page: per_page}

    socket = push_patch(socket, to: ~p"/paginate-params?#{params}")
    {:noreply, socket}
  end

  defp get_page_patch(page, options) do
    params = %{options | page: page}
    ~p"/paginate-params?#{params}"
  end

  defp get_pages(page, per_page, count) do
    page_count = ceil(count / per_page)

    for page_number <- (page - 5)..(page + 5),
        page_number > 0 and page_number <= page_count do
      page_number
    end
  end

  defp get_safe_page(page, per_page, count) do
    if(page * per_page > count) do
      ceil(count / per_page)
    else
      page
    end
  end

  defp to_integer(nil, default_value), do: default_value

  defp to_integer(value, default_value) do
    case Integer.parse(value) do
      {i, _} -> i
      :error -> default_value
    end
  end
end
