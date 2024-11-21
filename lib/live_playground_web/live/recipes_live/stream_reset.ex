defmodule LivePlaygroundWeb.RecipesLive.StreamReset do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries
  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(%{"country_id" => country_id}, _session, socket) do
    countries = Countries.list_region_country("Baltic Countries")

    try do
      selected_country = Countries.get_country!(country_id)
      cities = Cities.list_country_city(selected_country.code)
      {:ok, init_tab(socket, countries, selected_country, cities)}
    rescue
      Ecto.NoResultsError ->
        {:ok, init_tab(socket, countries, nil, [])}
    end
  end

  def mount(_params, _session, socket) do
    countries = Countries.list_region_country("Baltic Countries")

    case countries do
      [] ->
        {:ok, init_tab(socket, countries, nil, [])}

      countries ->
        selected_country = hd(countries)
        cities = Cities.list_country_city(selected_country.code)
        {:ok, init_tab(socket, countries, selected_country, cities)}
    end
  end

  defp init_tab(socket, countries, selected_country, cities) do
    socket
    |> assign(:countries, countries)
    |> assign(:selected_country, selected_country)
    |> assign(:cities_empty, Enum.empty?(cities))
    |> stream(:cities, cities)
  end

  def handle_params(%{"country_id" => country_id} = params, _url, socket) do
    try do
      selected_country = Countries.get_country!(country_id)

      socket =
        if socket.assigns.selected_country != selected_country do
          change_tab(socket, selected_country)
        else
          socket
        end

      {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    rescue
      Ecto.NoResultsError ->
        {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    end
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp change_tab(socket, selected_country) do
    socket
    |> assign(:selected_country, selected_country)
    |> stream(:cities, Cities.list_country_city(selected_country.code), reset: true)
  end

  defp apply_action(socket, :index, _params) do
    city = %City{}

    socket
    |> assign(:btn_title, "Add")
    |> assign(:city, city)
    |> assign_form(Cities.change_city(city))
  end

  defp apply_action(socket, :edit, %{"city_id" => city_id}) do
    try do
      city = Cities.get_city!(city_id)

      socket
      |> assign(:btn_title, "Update")
      |> assign(:city, city)
      |> assign_form(Cities.change_city(city))
    rescue
      Ecto.NoResultsError ->
        apply_action(socket, :index, %{})
    end
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Stream Reset
      <:subtitle>
        Resetting Streams With Navigation in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.alert :if={@countries == []} kind={:info} id="no-countries" class="mb-5">
      No countries available.
    </.alert>
    <.alert :if={@cities_empty} kind={:info} id="no-cities" class="mb-5">
      No cities available.
    </.alert>
    <.tabs :if={@countries != []} class="mb-5">
      <:tab :for={country <- @countries} path={~p"/stream-reset?#{[country_id: country.id]}"} active={country == @selected_country}>
        <%= country.name %>
      </:tab>
    </.tabs>
    <.form
      :if={@countries != []}
      for={@form}
      phx-change="validate"
      phx-submit="save"
      class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0"
    >
      <.input field={@form[:name]} label="Name" class="flex-auto" />
      <.input field={@form[:district]} label="District" class="flex-auto" />
      <.input field={@form[:population]} label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="" class="md:mt-8"><%= @btn_title %></.button>
      </div>
      <div :if={@live_action == :edit && @selected_country}>
        <.button_link kind={:secondary} patch={~p"/stream-reset?#{[country_id: @selected_country.id]}"} class="w-full md:mt-8">
          Cancel
        </.button_link>
      </div>
    </.form>
    <.table :if={!@cities_empty} id="cities" rows={@streams.cities}>
      <:col :let={{_id, city}} label="Name">
        <%= city.name %>
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-zinc-700"><%= city.district %></dd>
        </dl>
        <dl class="hidden md:block font-normal text-xs text-zinc-400">
          <dt>Stream inserted:</dt>
          <dd><%= Timex.now() %></dd>
        </dl>
      </:col>
      <:col :let={{_id, city}} label="District" class="hidden md:table-cell"><%= city.district %></:col>
      <:col :let={{_id, city}} label="Population" class="text-right md:pr-10">
        <%= Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ") %>
      </:col>
      <:action :let={{id, city}}>
        <.link patch={~p"/stream-reset/edit?#{[country_id: @selected_country.id, city_id: city.id]}"} class="md:mr-4">
          <span class="hidden md:inline">Edit</span> <.icon name="hero-pencil-square-mini" class="md:hidden h-6 w-6" />
        </.link>
        <.link phx-click={JS.push("delete", value: %{city_id: city.id}) |> hide("##{id}")} data-confirm="Are you sure?">
          <span class="hidden md:inline">Delete</span> <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/stream_reset.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# streamreset" to="# endstreamreset" />
      <.code_block filename="lib/live_playground/countries.ex" from="# streamreset" to="# endstreamreset" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/stream_reset.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("delete", %{"city_id" => city_id}, socket) do
    city = Cities.get_city!(city_id)
    {:ok, _} = Cities.delete_city_broadcast(city)

    {:noreply, stream_delete(socket, :cities, city)}
  end

  def handle_event("validate", %{"city" => city_params}, socket) do
    changeset =
      socket.assigns.city
      |> Cities.change_city(city_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"city" => city_params}, socket) do
    save_city(socket, socket.assigns.live_action, city_params)
  end

  defp save_city(socket, :index, city_params) do
    city_params = Map.put(city_params, "countrycode", socket.assigns.selected_country.code)

    case Cities.create_city(city_params) do
      {:ok, city} ->
        {:noreply,
         socket
         |> stream_insert(:cities, city, at: 0)
         |> push_patch(to: ~p"/stream-reset?#{[country_id: socket.assigns.selected_country.id]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_city(socket, :edit, city_params) do
    case Cities.update_city(socket.assigns.city, city_params) do
      {:ok, city} ->
        {:noreply,
         socket
         |> stream_insert(:cities, city)
         |> push_patch(to: ~p"/stream-reset?#{[country_id: socket.assigns.selected_country.id]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
