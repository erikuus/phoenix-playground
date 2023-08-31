defmodule LivePlaygroundWeb.CityLive.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries
  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(%{"country_id" => country_id} = params, _session, socket) do
    if connected?(socket), do: Cities.subscribe()
    {:ok, assign_defaults(socket)}
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Cities.subscribe()
    socket = assign_defaults(socket)
    {:ok, stream(socket, :cities, Cities.list_country_city(socket.assigns.selected_country.code))}
  end

  defp assign_defaults(socket) do
    countries = Countries.list_region_country("Baltic Countries")
    country = hd(countries)

    socket
    |> assign(:countries, countries)
    |> assign(:selected_country, country)
  end

  def handle_params(%{"country_id" => country_id} = params, _url, socket) do
    country = Countries.get_country!(country_id)

    socket =
      if socket.assigns.selected_country != country do
        stream(socket, :cities, Cities.list_country_city(country.code), reset: true)
      else
        socket
      end

    socket =
      socket
      |> assign(:selected_country, country)
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:title, nil)
    |> assign(:city, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:title, "New City")
    |> assign(:city, %City{})
  end

  defp apply_action(socket, :edit, %{"city_id" => city_id}) do
    socket
    |> assign(:title, "Edit City")
    |> assign(:city, Cities.get_city!(city_id))
  end

  def handle_event("delete", %{"city_id" => id}, socket) do
    city = Cities.get_city!(id)
    {:ok, _} = Cities.delete_city_broadcast(city)

    {:noreply, socket}
  end

  def handle_info({:create_city, city}, socket) do
    {:noreply, stream_insert(socket, :cities, city, at: 0)}
  end

  def handle_info({:update_city, city}, socket) do
    {:noreply, stream_insert(socket, :cities, city)}
  end

  def handle_info({:delete_city, city}, socket) do
    {:noreply, stream_delete(socket, :cities, city)}
  end
end
