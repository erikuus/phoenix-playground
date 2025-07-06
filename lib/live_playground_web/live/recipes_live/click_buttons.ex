defmodule LivePlaygroundWeb.RecipesLive.ClickButtons do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    case Countries.list_region_country("Baltic Countries") do
      [] ->
        {:ok, assign(socket, countries: [], selected_country: nil)}

      countries ->
        {:ok, assign(socket, countries: countries, selected_country: hd(countries))}
    end
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Click Buttons
      <:subtitle>
        Handling Button Click Events in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 md:flex-row md:space-x-3 md:space-y-0">
      <.button_link
        :for={country <- @countries}
        phx-click="select-country"
        phx-value-id={country.id}
        kind={get_button_kind(country, @selected_country)}
      >
        {country.name}
      </.button_link>
    </div>
    <.country_details selected_country={@selected_country} />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/click_buttons.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# clickbuttons" to="# endclickbuttons" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/click_buttons.html" />
    <!-- end hiding from live code -->
    """
  end

  defp country_details(%{selected_country: nil} = assigns) do
    ~H"""
    <.alert kind={:info} close={false}>
      No countries found in the specified region.
    </.alert>
    """
  end

  defp country_details(assigns) do
    ~H"""
    <.list class="mt-6 mb-16 ml-1">
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

  def handle_event("select-country", %{"id" => id}, socket) do
    socket = assign(socket, :selected_country, Countries.get_country!(id))
    {:noreply, socket}
  end

  defp get_button_kind(country, selected_country) do
    if country == selected_country, do: :primary, else: :secondary
  end
end
