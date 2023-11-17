defmodule LivePlaygroundWeb.RecipesLive.HandleParams do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        countries: Countries.list_region_country("Baltic Countries")
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    country = Countries.get_country!(id)
    {:noreply, assign(socket, :selected_country, country)}
  end

  def handle_params(_params, _url, socket) do
    country = hd(socket.assigns.countries)
    {:noreply, assign(socket, :selected_country, country)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle Parameters
      <:subtitle>
        How to handle url parameteres in LiveView
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <.tabs :if={@countries != []}>
      <:tab :for={country <- @countries} path={~p"/handle-params?#{[id: country.id]}"} active={country == @selected_country}>
        <%= country.name %>
      </:tab>
    </.tabs>

    <.list class="mt-6 mb-16">
      <:item title="Code"><%= @selected_country.code %></:item>
      <:item title="Continent"><%= @selected_country.continent %></:item>
      <:item title="Region"><%= @selected_country.region %></:item>
      <:item title="The year of independence"><%= @selected_country.indepyear %></:item>
      <:item title="The form of government"><%= @selected_country.governmentform %></:item>
      <:item title="The head of state"><%= @selected_country.headofstate %></:item>
      <:item title="Population">
        <%= Number.Delimit.number_to_delimited(@selected_country.population, precision: 0, delimiter: " ") %>
      </:item>
      <:item title="GNP">
        <%= Number.Delimit.number_to_delimited(@selected_country.gnp, precision: 0, delimiter: " ") %>
      </:item>
      <:item title="Life expectancy">
        <%= Number.Delimit.number_to_delimited(@selected_country.lifeexpectancy, precision: 2) %>
      </:item>
    </.list>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/handle_params.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# handleparams" to="# endhandleparams" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
