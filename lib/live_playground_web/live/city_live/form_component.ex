defmodule LivePlaygroundWeb.CityLive.FormComponent do
  use LivePlaygroundWeb, :live_component

  alias LivePlayground.Cities

  def update(%{city: city} = assigns, socket) do
    changeset = Cities.change_city(city)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %> in <%= @country.name %>
        <:subtitle>Use this form to manage city records in your database.</:subtitle>
      </.header>
      <.simple_form for={@form} id="city-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:district]} label="District" />
        <.input field={@form[:population]} label="Population" />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def handle_event("validate", %{"city" => city_params}, socket) do
    changeset =
      socket.assigns.city
      |> Cities.change_city(city_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"city" => city_params}, socket) do
    save_city(socket, socket.assigns.action, city_params)
  end

  defp save_city(socket, :new, city_params) do
    city_params = Map.put(city_params, "countrycode", socket.assigns.country.code)

    case Cities.create_city_broadcast(city_params) do
      {:ok, _city} ->
        {:noreply, push_patch(socket, to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_city(socket, :edit, city_params) do
    case Cities.update_city_broadcast(socket.assigns.city, city_params) do
      {:ok, _city} ->
        {:noreply, push_patch(socket, to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
