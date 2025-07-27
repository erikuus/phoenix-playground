defmodule LivePlaygroundWeb.RecipesLive.Search do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  @demo_delay 1000

  def mount(_params, _session, socket) do
    {:ok, assign_empty_search(socket)}
  end

  defp assign_empty_search(socket) do
    socket
    |> assign(:query, nil)
    |> assign(:countries, [])
    |> assign(:loading, false)
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle-event Search
      <:subtitle>
        Creating a Search Interface Without URL Parameters in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form class="mb-4 flex space-x-3" phx-submit="search">
      <div class="w-72">
        <.input type="text" name="query" autocomplete="off" placeholder="Country" value={@query} disabled={@loading} />
      </div>
      <.button type="submit" phx-disable-with="" disabled={@loading}>
        Search <.loading :if={@loading} class="ml-2 -mr-2 w-5 h-5" />
      </.button>
    </form>
    <.alert flash={@flash} flash_key={:no_result} />
    <.table :if={@countries != []} id="countries" rows={@countries}>
      <:col :let={country} label="Name">{country.name}</:col>
      <:col :let={country} label="Continent">{country.continent}</:col>
      <:col :let={country} label="Population" class="text-right">
        <div class="text-right">
          {Number.Delimit.number_to_delimited(country.population, precision: 0, delimiter: " ")}
        </div>
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/search.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# search" to="# endsearch" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/search.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("search", %{"query" => ""}, socket) do
    socket =
      socket
      |> assign_empty_search()
      |> put_flash(:no_result, "Please enter a search term")

    {:noreply, socket}
  end

  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:find, query})

    socket =
      socket
      |> assign(:query, query)
      |> assign(:countries, [])
      |> assign(:loading, true)
      |> clear_flash()

    {:noreply, socket}
  end

  def handle_info({:find, query}, socket) do
    Process.sleep(@demo_delay)

    case Countries.list_country(query) do
      [] ->
        socket =
          socket
          |> assign(:loading, false)
          |> put_flash(:no_result, "No results for \"#{query}\"")

        {:noreply, socket}

      countries ->
        socket =
          socket
          |> assign(:countries, countries)
          |> assign(:loading, false)

        {:noreply, socket}
    end
  end
end
