defmodule LivePlaygroundWeb.PaginateLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    page = params["page"] |> to_integer(1)
    per_page = params["per_page"] |> to_integer(10)

    count = Cities.count_city()

    page =
      if(page * per_page > count) do
        ceil(count / per_page)
      else
        page
      end

    options = %{
      page: page,
      per_page: per_page
    }

    socket =
      assign(socket,
        cities: Cities.list_city(options),
        options: options,
        count: count
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Pagination
      <:subtitle>
        How to paginate data in live view
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <form phx-change="select-per-page" class="flex md:flex-row-reverse md:-mt-24">
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
      <:col :let={city} label="District" class="hidden md:table-cell"><%= city.district %></:col>
      <:col :let={city} label="Population" class="text-right">
        <%= Number.Delimit.number_to_delimited(city.population,
          precision: 0,
          delimiter: " "
        ) %>
      </:col>
    </.table>
    <.pages>
      <:prev_icon><.icon name="hero-arrow-long-left" class="mr-3 h-5 w-5 text-gray-400" /></:prev_icon>
      <:prev :if={@options.page > 1} patch={get_page_patch(@options.page - 1, @options)}>Previous</:prev>
      <:page :for={page <- get_pages(@options, @count)} patch={get_page_patch(page, @options)} active={@options.page == page}>
        <%= page %>
      </:page>
      <:next :if={@options.page * @options.per_page < @count} patch={get_page_patch(@options.page + 1, @options)}>Next</:next>
      <:next_icon><.icon name="hero-arrow-long-right" class="ml-3 h-5 w-5 text-gray-400" /></:next_icon>
    </.pages>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/paginate_live.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# paginate", "# endpaginate")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("select-per-page", %{"per_page" => per_page}, socket) do
    params = %{socket.assigns.options | per_page: per_page}

    socket = push_patch(socket, to: ~p"/paginate?#{params}")
    {:noreply, socket}
  end

  defp get_page_patch(page, options) do
    params = %{options | page: page}
    ~p"/paginate?#{params}"
  end

  defp get_pages(options, count) do
    page_count = ceil(count / options.per_page)

    for page_number <- (options.page - 5)..(options.page + 5),
        page_number > 0 and page_number <= page_count do
      page_number
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
