defmodule LivePlaygroundWeb.RecipesLive.FormInsert do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        cities: Cities.list_est_city(),
        form: get_empty_form()
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Insert Form
      <:subtitle>
        How to create insert form that validates on submit
      </:subtitle>
      <:actions>
        <.link navigate={~p"/form-insert-validate"}>
          See also: Validate on Change <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-submit="save" class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0">
      <.input field={@form[:name]} label="Name" class="flex-auto" />
      <.input field={@form[:district]} label="District" class="flex-auto" />
      <.input field={@form[:population]} label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="" class="md:mt-8">Save</.button>
      </div>
    </.form>
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name">
        <%= city.name %>
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-gray-700"><%= city.district %></dd>
        </dl>
      </:col>
      <:col :let={city} label="District" class="hidden md:table-cell"><%= city.district %></:col>
      <:col :let={city} label="Population" class="text-right">
        <%= Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ") %>
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/recipes_live/form_insert.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# form", "# endform")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("save", %{"city" => params}, socket) do
    params = Map.put(params, "countrycode", "EST")

    case Cities.create_city(params) do
      {:ok, city} ->
        socket = update(socket, :cities, &[city | &1])
        socket = assign(socket, :form, get_empty_form())

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  defp get_empty_form() do
    %City{}
    |> Cities.change_city()
    |> to_form()
  end
end
