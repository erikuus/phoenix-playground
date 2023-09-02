defmodule LivePlaygroundWeb.CityLive.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries
  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(%{"country_id" => country_id} = params, _session, socket) do
    if connected?(socket), do: Cities.subscribe()

    countries = Countries.list_region_country("Baltic Countries")
    selected_country = Countries.get_country!(country_id)
    {:ok, init_tab(socket, countries, selected_country)}
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Cities.subscribe()

    countries = Countries.list_region_country("Baltic Countries")
    selected_country = hd(countries)
    {:ok, init_tab(socket, countries, selected_country)}
  end

  defp init_tab(socket, countries, selected_country) do
    socket
    |> assign(:countries, countries)
    |> assign(:selected_country, selected_country)
    |> stream(:cities, Cities.list_country_city(selected_country.code))
  end

  def handle_params(%{"country_id" => country_id} = params, _url, socket) do
    socket =
      if socket.assigns.selected_country.id != String.to_integer(country_id) do
        socket = change_tab(socket, country_id)
      else
        socket
      end

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp change_tab(socket, country_id) do
    selected_country = Countries.get_country!(country_id)

    socket
    |> assign(:selected_country, selected_country)
    |> stream(:cities, Cities.list_country_city(selected_country.code), reset: true)
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
