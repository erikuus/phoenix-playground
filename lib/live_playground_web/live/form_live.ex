defmodule LivePlaygroundWeb.FormLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    changeset = Cities.change_city(%City{})

    socket =
      assign(socket,
        cities: Cities.list_est_city(),
        form: to_form(changeset)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Form
      <:subtitle>
        How to save data within live view
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-submit="save" class="flex flex-col space-x-0 space-y-4 lg:flex-row lg:space-x-4 lg:space-y-0">
      <.input field={@form[:name]} label="Name" class="flex-auto" />
      <.input field={@form[:district]} label="District" class="flex-auto" />
      <.input field={@form[:population]} label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="Saving ..." class="lg:mt-8">Save</.button>
      </div>
    </.form>
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name">
        <%= city.name %>
      </:col>
      <:col :let={city} label="District">
        <%= city.district %>
      </:col>
      <:col :let={city} label="Population" class="text-right">
        <div class="text-right">
          <%= Number.Delimit.number_to_delimited(city.population,
            precision: 0,
            delimiter: " "
          ) %>
        </div>
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/form_live.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# form", "# endform")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("save", %{"city" => params}, socket) do
    params = Map.put(params, "countrycode", "EST")

    case Cities.create_city(params) do
      {:ok, city} ->
        IO.inspect(city)
        socket = update(socket, :cities, &[city | &1])

        changeset = Cities.change_city(%City{})
        socket = assign(socket, :form, to_form(changeset))

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end
end
