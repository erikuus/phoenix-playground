defmodule LivePlaygroundWeb.SearchAdvancedLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent
  import LivePlaygroundWeb.IconComponent

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"q" => query}, _url, socket) do
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
      Advanced Search
      <:footer>
        How to search in live view with url parameter
      </:footer>
      <:buttons>
        <.button navigate="/search" color={:secondary}>
          Back to simple search
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
      <.button type="submit">
        Search
      </.button>
      <.button patch={Routes.live_path(@socket, __MODULE__)} color={:secondary}>
        Clear
      </.button>
    </form>
    <.icon :if={@loading} name="circle" class="animate-spin ml-2 -mr-1 w-5 h-5"/>
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
      <%= raw(code("lib/live_playground_web/live/search_advanced_live.ex")) %>
      <%= raw(code("lib/live_playground/countries.ex", "# search", "# endsearch")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("search", %{"query" => query}, socket) do
    socket =
      push_patch(socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            q: query
          )
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
