defmodule LivePlaygroundWeb.RecipesLive.StreamUpdate do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cities, Cities.list_country_city("EST"))}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(params, socket.assigns.live_action, socket)}
  end

  defp apply_action(_params, :index, socket) do
    socket
  end

  defp apply_action(%{"id" => id}, :edit, socket) do
    city = Cities.get_city!(id)

    assign(socket,
      city: city,
      form: get_city_form(city)
    )
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Stream Update
      <:subtitle>
        Updating Items in Large Collections Without Server-Side Memory Storage in LiveView
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <.form
      :if={@live_action == :edit}
      for={@form}
      phx-submit="save"
      class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0"
    >
      <.input field={@form[:name]} phx-debounce="2000" label="Name" class="flex-auto" />
      <.input field={@form[:district]} phx-debounce="2000" label="District" class="flex-auto" />
      <.input field={@form[:population]} phx-debounce="2000" label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="" class="w-full md:mt-8">Save</.button>
      </div>
      <div>
        <.button_link kind={:secondary} patch={~p"/stream-update"} class="w-full md:mt-8">
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
        <dl class="hidden md:block font-normal text-xs text-zinc-400">
          <dt>Stream inserted:</dt>
          <dd><%= Timex.now() %></dd>
        </dl>
      </:col>
      <:col :let={{_id, city}} label="District" class="hidden md:table-cell"><%= city.district %></:col>
      <:col :let={{_id, city}} label="Population" class="text-right md:pr-10">
        <%= Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ") %>
      </:col>
      <:action :let={{_id, city}}>
        <.link patch={~p"/stream-update/edit?#{[id: city.id]}"}>
          <span class="hidden md:inline">Edit</span>
          <.icon name="hero-pencil-square-mini" class="md:hidden h-6 w-6" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/stream_update.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# streamupdate" to="# endstreamupdate" />
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
