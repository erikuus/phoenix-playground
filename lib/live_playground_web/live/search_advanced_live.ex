defmodule LivePlaygroundWeb.SearchAdvancedLive do
  use LivePlaygroundWeb, :live_view

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
    <.header class="mb-6">
      Advanced Search
      <:subtitle>
        How to search in live view with url parameter
      </:subtitle>
      <:actions>
        <.link navigate={~p"/search"}>
          Back to simple search
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form class="w-96 mb-4 flex space-x-2 items-center" phx-submit="search">
      <.input type="text" name="query" autocomplete="off" placeholder="Country" value={@query} readonly={@loading} />
      <.button type="submit">
        Search
      </.button>
      <.button_link type="secondary" patch={~p"/search-advanced"}>
        Clear
      </.button_link>
    </form>
    <.loading :if={@loading} />
    <.alert :if={@flash["no_result"]}>
      <%= live_flash(@flash, :no_result) %>
    </.alert>
    <.table :if={@countries != []} id="countries" rows={@countries}>
      <:col :let={country} label="Name"><%= country.name %></:col>
      <:col :let={country} label="Continent"><%= country.continent %></:col>
      <:col :let={country} label="Population" class="text-right">
        <div class="text-right">
          <%= Number.Delimit.number_to_delimited(country.population, precision: 0, delimiter: " ") %>
        </div>
      </:col>
    </.table>
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
        to: ~p"/search-advanced?#{[q: query]}"
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
