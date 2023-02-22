defmodule LivePlaygroundWeb.SearchLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent
  import LivePlaygroundWeb.IconComponent

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
      <:buttons>
        <.button href="/search-advanced" color={:secondary}>
          Try advanced search
        </.button>
      </:buttons>
    </.heading>
    <!-- end hiding from live code -->
    <form class="mb-4 flex space-x-2" phx-submit="search">
      <.input
        type="text"
        name="query"
        autocomplete="off"
        placeholder="Search Country by Name"
        class="w-96 placeholder-gray-300"
        value={@query}
        readonly={@loading} />
      <.button type="submit" class="inline-flex">
        Search <.icon :if={@loading} name="circle" class="animate-spin ml-2 -mr-1 w-5 h-5"/>
      </.button>
    </form>
    <.alert :if={@flash["no_result"]}>
      <%= live_flash(@flash, :no_result) %>
    </.alert>    
    <.ul :if={@countries != []} class="mb-4">
      <.li :for={country <- @countries} class="sm:flex sm:items-center sm:justify-between">
        <p class="w-80 truncate font-medium"><%= country.name %></p>
        <p class="w-12 text-sm"><%= country.code %></p>
        <p class="w-12 text-sm"><%= country.code2 %></p>
      </.li>
    </.ul>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/search_live.ex")) %>
      <%= raw(code("lib/live_playground/countries.ex", "# search", "# endsearch")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:find, query})

    socket =
      socket
      |> clear_flash()
      |> assign(
        query: query,
        countries: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:find, query}, socket) do
    #  For demo we wait a second to show loading
    Process.sleep(1000)

    case Countries.list_country(query) do
      [] ->
        socket =
          socket
          |> put_flash(:no_result, "No results for \"#{query}\"")
          |> assign(loading: false)

        {:noreply, socket}

      countries ->
        socket =
          assign(socket,
            countries: countries,
            loading: false
          )

        {:noreply, socket}
    end
  end
end
