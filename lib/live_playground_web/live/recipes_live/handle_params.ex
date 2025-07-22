defmodule LivePlaygroundWeb.RecipesLive.HandleParams do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  @region "Baltic Countries"

  def mount(_params, _session, socket) do
    countries = Countries.list_region_country(@region)
    {:ok, assign(socket, :countries, countries)}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    country = Countries.get_country!(id)
    {:noreply, assign(socket, :selected_country, country)}
  end

  def handle_params(_params, _url, socket) do
    case socket.assigns.countries do
      [] ->
        {:noreply, assign(socket, :selected_country, nil)}

      countries ->
        {:noreply, assign(socket, :selected_country, hd(countries))}
    end
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Handle Parameters
      <:subtitle>
        Managing URL Parameters in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.tabs :if={@countries != []} class="mb-6">
      <:tab :for={country <- @countries} path={~p"/handle-params?#{[id: country.id]}"} active={country == @selected_country}>
        {country.name}
      </:tab>
    </.tabs>
    <.country_details countries={@countries} selected_country={@selected_country} />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/handle_params.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# handleparams" to="# endhandleparams" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/handle_params.html" />
    <!-- end hiding from live code -->
    """
  end

  defp country_details(%{countries: []} = assigns) do
    ~H"""
    <.alert kind={:info} close={false}>
      No countries found in the specified region.
    </.alert>
    """
  end

  defp country_details(assigns) do
    ~H"""
    <.list class="mb-16 ml-1">
      <:item title="Code">{@selected_country.code}</:item>
      <:item title="Continent">{@selected_country.continent}</:item>
      <:item title="Region">{@selected_country.region}</:item>
      <:item title="The year of independence">{@selected_country.indepyear}</:item>
      <:item title="The form of government">{@selected_country.governmentform}</:item>
      <:item title="The head of state">{@selected_country.headofstate}</:item>
      <:item title="Population">
        {Number.Delimit.number_to_delimited(@selected_country.population, precision: 0, delimiter: " ")}
      </:item>
      <:item title="GNP">
        {Number.Delimit.number_to_delimited(@selected_country.gnp, precision: 0, delimiter: " ")}
      </:item>
      <:item title="Life expectancy">
        {Number.Delimit.number_to_delimited(@selected_country.lifeexpectancy, precision: 2)}
      </:item>
    </.list>
    """
  end
end
