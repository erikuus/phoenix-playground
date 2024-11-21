defmodule LivePlaygroundWeb.RecipesLive.BroadcastStream do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    if connected?(socket), do: Cities.subscribe()

    {:ok, stream(socket, :cities, Cities.list_country_city("EST"))}
  end

  def terminate(_reason, _socket) do
    # Ensure we unsubscribe when the LiveView is terminated to clean up resources
    Cities.unsubscribe()
    :ok
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    city = %City{}
    set_form(socket, "Add", city)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    try do
      city = Cities.get_city!(id)
      set_form(socket, "Update", city)
    rescue
      Ecto.NoResultsError ->
        socket
        |> put_flash(:error, "City not found.")
        |> apply_action(:index, %{})
    end
  end

  defp set_form(socket, btn_title, city) do
    socket
    |> assign(:btn_title, btn_title)
    |> assign(:city, city)
    |> assign_form(Cities.change_city(city))
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Real-Time Updates with Stream
      <:subtitle>
        Broadcasting Updates With Streams and Optimistic Locking in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form
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
      <div :if={@live_action == :edit}>
        <.button_link kind={:secondary} patch={~p"/broadcast-stream"} class="w-full md:mt-8">
          Cancel
        </.button_link>
      </div>
    </.form>
    <.table id="cities" rows={@streams.cities}>
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
        <.link patch={~p"/broadcast-stream/edit?#{[id: city.id]}"} class="md:mr-4">
          <span class="hidden md:inline">Edit</span>
          <.icon name="hero-pencil-square-mini" class="md:hidden h-6 w-6" />
        </.link>
        <.link phx-click={JS.push("delete", value: %{id: city.id}) |> hide("##{id}")} data-confirm="Are you sure?">
          <span class="hidden md:inline">Delete</span>
          <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/broadcast_stream.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# broadcaststream_" to="# endbroadcaststream_" />
      <.code_block filename="lib/live_playground/cities/city.ex" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/broadcast_stream.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    city = Cities.get_city!(id)
    {:ok, _} = Cities.delete_city_broadcast(city)

    {:noreply, socket}
  end

  def handle_event("validate", %{"city" => params}, socket) do
    changeset =
      socket.assigns.city
      |> Cities.change_city(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"city" => params}, socket) do
    save_city(socket, socket.assigns.live_action, params)
  end

  defp save_city(socket, :index, params) do
    params = Map.put(params, "countrycode", "EST")

    case Cities.create_city_broadcast(params) do
      {:ok, _city} ->
        {:noreply, push_patch(socket, to: ~p"/broadcast-stream")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_city(socket, :edit, params) do
    # Retrieve the city from the database using the ID stored in the socket's assigns
    city = Cities.get_city!(socket.assigns.city.id)

    # Check if the lock_version from the database matches the version in the socket's assigns
    # This is used to detect if the city has been modified by another user since it was last fetched
    if city.lock_version != socket.assigns.city.lock_version do
      # If the lock_version does not match, inform the user via a flash message
      socket = put_flash(socket, :error, "This city has been modified by someone else.")
      # Return without making any changes as the city data on the user's side is stale
      {:noreply, socket}
    else
      # If the lock_version matches, proceed to update the city with the new parameters
      case Cities.update_city_broadcast(city, params) do
        {:ok, _city} ->
          {:noreply, push_patch(socket, to: ~p"/broadcast-stream")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign_form(socket, changeset)}
      end
    end
  end

  def handle_info({:create_city, city}, socket) do
    {:noreply, stream_insert(socket, :cities, city, at: 0)}
  end

  def handle_info({:update_city, city}, socket) do
    if city.id == socket.assigns.city.id && socket.assigns.live_action == :edit do
      # Notify the user about the update
      socket =
        socket
        |> stream_insert(:cities, city)
        |> put_flash(:info, "This city's details have just been updated by another user.")

      {:noreply, socket}
    else
      {:noreply, stream_insert(socket, :cities, city)}
    end
  end

  def handle_info({:delete_city, city}, socket) do
    {:noreply, stream_delete(socket, :cities, city)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
