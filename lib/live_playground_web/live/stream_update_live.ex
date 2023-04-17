defmodule LivePlaygroundWeb.StreamUpdateLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cities, Cities.list_est_city())}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    city = Cities.get_city!(id)

    socket =
      assign(socket,
        city: city,
        form: get_city_form(city)
      )

    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, city: nil, form: nil)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Stream Update
      <:subtitle>
        How to update items in large collections without keeping them in memory on the server
      </:subtitle>
      <:actions>
        <.link navigate={~p"/stream-insert"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Stream Insert
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form :if={@form} for={@form} phx-submit="save" class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0">
      <.input field={@form[:name]} phx-debounce="2000" label="Name" class="flex-auto" />
      <.input field={@form[:district]} phx-debounce="2000" label="District" class="flex-auto" />
      <.input field={@form[:population]} phx-debounce="2000" label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="" class="w-full md:mt-8">Save</.button>
      </div>
      <div>
        <.button_link type="secondary" patch={~p"/stream-update"} class="w-full md:mt-8">
          Cancel
        </.button_link>
      </div>
    </.form>
    <.table id="cities" rows={@streams.cities}>
      <:col :let={{_id, city}} label="Name">
        <%= city.name %>
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-gray-700"><%= city.district %></dd>
        </dl>
      </:col>
      <:col :let={{_id, city}} label="District" class="hidden md:table-cell"><%= city.district %></:col>
      <:col :let={{_id, city}} label="Population" class="text-right md:pr-10">
        <%= Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ") %>
      </:col>
      <:action :let={{_id, city}}>
        <.link patch={~p"/stream-update?#{[id: city.id]}"}>update</.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/stream_update_live.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# form", "# endform")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("save", %{"city" => params}, socket) do
    case Cities.update_city(socket.assigns.city, params) do
      {:ok, city} ->
        socket =
          socket
          |> stream_insert(:cities, city)
          |> push_patch(to: ~p"/stream-update")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  defp get_city_form(city) do
    city
    |> Cities.change_city()
    |> to_form()
  end
end
