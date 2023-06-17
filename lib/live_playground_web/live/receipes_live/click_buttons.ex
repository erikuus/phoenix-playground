defmodule LivePlaygroundWeb.ReceipesLive.ClickButtons do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    countries = Countries.list_nordic_country()

    socket =
      assign(socket,
        countries: countries,
        selected_country: hd(countries)
      )

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Click Buttons
      <:subtitle>
        How to handle click events in LiveView
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 md:flex-row md:space-x-3 md:space-y-0">
      <.button_link
        :for={country <- @countries}
        phx-click="select-country"
        phx-value-id={country.id}
        type={get_button_type(country, @selected_country)}
      >
        <%= country.name %>
      </.button_link>
    </div>

    <.list class="mt-6 mb-16 ml-1">
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
      <%= raw(code("lib/live_playground_web/live/receipes_live/click_buttons.ex")) %> <%= raw(
        code("lib/live_playground/countries.ex", "# listnordiccountry", "# endlistnordiccountry")
      ) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("select-country", %{"id" => id}, socket) do
    socket = assign(socket, :selected_country, Countries.get_country!(id))
    {:noreply, socket}
  end

  def get_button_type(country, selected_country) do
    if country == selected_country, do: "primary", else: "secondary"
  end
end
