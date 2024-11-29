defmodule LivePlaygroundWeb.RecipesLive.SearchParam do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"q" => ""}, _url, socket) do
    socket =
      socket
      |> put_flash(:no_result, "Please enter a search term")
      |> assign_empty_search()

    {:noreply, socket}
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
    {:noreply, assign_empty_search(socket)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle-params Search
      <:subtitle>
        Developing a Search Interface With URL Parameters in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form phx-submit="search" class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0 md:w-96 mb-6">
      <.input type="text" name="query" autocomplete="off" placeholder="Country" value={@query} disabled={@loading} />
      <.button type="submit" phx-disable-with="" disabled={@loading}>
        Search
      </.button>
      <.button_link kind={:secondary} patch={~p"/search-param"}>
        Clear
      </.button_link>
    </form>
    <.loading :if={@loading} />
    <.alert flash={@flash} flash_key={:no_result} />
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
      <.code_block filename="lib/live_playground_web/live/recipes_live/search_param.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# search" to="# endsearch" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/search_param.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("search", %{"query" => query}, socket) do
    if query != socket.assigns.query do
      socket =
        push_patch(socket,
          to: ~p"/search-param?#{[q: query]}"
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
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

  defp assign_empty_search(socket) do
    assign(socket,
      query: nil,
      countries: [],
      loading: false
    )
  end
end
