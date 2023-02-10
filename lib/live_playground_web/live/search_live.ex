defmodule LivePlaygroundWeb.SearchLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    socket =
      assign(socket,
        query: nil,
        countries: [],
        loading: false
      )

    {:noreply, socket}
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
      <.button patch={Routes.live_path(@socket, __MODULE__)} color={:secondary}>Clear</.button>
    </form>
    <div :if={@loading} class="my-10 text-lg">
      Loading ...
    </div>
    <.ul :if={@countries != []} class="mb-4">
      <li :for={country <- @countries} class="p-4 sm:flex sm:items-center sm:justify-between">
        <p class="w-80 truncate font-medium"><%= country.name %></p>
        <p class="w-12 text-sm"><%= country.code %></p>
        <p class="w-12 text-sm"><%= country.code2 %></p>
        <p class="w-10 text-sm sm:text-right"><%= country.code_number %></p>  
      </li>
    </.ul> 
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/search_live.ex")) %>
      <%= raw(code("lib/live_playground/countries.ex", "# search", "# endsearch")) %>
    </div>
    <!-- end hiding from live code -->        		
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
