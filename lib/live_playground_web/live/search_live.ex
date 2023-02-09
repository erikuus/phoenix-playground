defmodule LivePlaygroundWeb.SearchLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        query: nil,
        countries: [],
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.heading>
      Search
      <:footer>
        How to search in live view
      </:footer>
    </.heading>
    <!-- end hiding from live code -->
    <form class="mb-4 flex space-x-2 w-96" phx-submit="search">
      <.input 
        type="text" 
        name="query" 
        autocomplete="off" 
        placeholder="Search Country by Name"
        class="placeholder-gray-300"
        value={@query} 
        readonly={@loading} />
      <.button type="submit">Search</.button>
    </form>
    <div :if={@loading} class="my-10 text-lg">
      Loading ...
    </div>
    <ul class="mb-4 divide-y divide-gray-200">
      <li :for={country <- @countries} class="py-4"><%= country.name %></li>
    </ul>     		
    """
  end

  def handle_event("search", %{"query" => query}, socket) when is_binary(query) do
    send(self(), {:find, query})

    socket =
      assign(socket,
        query: query,
        countries: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:find, query}, socket) do
    case Countries.list_country(query) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No results for \"#{query}\"")
          |> assign(
            countries: [],
            loading: false
          )

        {:noreply, socket}

      countries ->
        socket =
          socket
          |> clear_flash()
          |> assign(
            countries: countries,
            loading: false
          )

        {:noreply, socket}
    end
  end
end
