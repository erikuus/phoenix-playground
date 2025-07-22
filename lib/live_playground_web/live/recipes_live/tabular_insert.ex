defmodule LivePlaygroundWeb.RecipesLive.TabularInsert do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  @countrycode "EST"

  def mount(_params, _session, socket) do
    if connected?(socket), do: Cities.subscribe()

    socket =
      socket
      |> assign(:tabular_input_ids, [])
      |> stream(:tabular_inputs, [])
      |> stream(:cities, Cities.list_country_city(@countrycode))

    {:ok, socket}
  end

  def terminate(_reason, _socket) do
    # Ensure we unsubscribe when the LiveView is terminated to clean up resources
    Cities.unsubscribe()
    :ok
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Tabular Insert
      <:subtitle>
        Inserting Multiple Items via Stream and Broadcast in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form phx-submit="save" class="space-y-6 md:space-y-4">
      <div id="tabular_inputs" phx-update="stream" class="space-y-4">
        <div
          :for={{id, tabular_input} <- @streams.tabular_inputs}
          id={id}
          class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0"
        >
          <.input field={tabular_input.form[:name]} id={"city_name_#{id}"} multiple={true} placeholder="Name" class="flex-1" />
          <.input
            field={tabular_input.form[:district]}
            id={"city_district_#{id}"}
            multiple={true}
            placeholder="District"
            class="flex-1"
          />
          <.input
            field={tabular_input.form[:population]}
            id={"city_population_#{id}"}
            multiple={true}
            placeholder="Population"
            class="flex-1"
          />
          <div class="flex flex-col md:flex-none">
            <.button type="button" kind={:secondary} phx-click="remove-tabular-input" phx-value-id={tabular_input.id} class="md:flex">
              Remove
            </.button>
          </div>
        </div>
      </div>
      <div class="flex flex-col space-x-0 space-y-2 md:flex-row md:space-x-2 md:space-y-0">
        <.button :if={Enum.count(@tabular_input_ids) < 5} type="button" phx-click="add-tabular-input">
          Add
        </.button>
        <.button :if={Enum.count(@tabular_input_ids) > 0} type="submit">
          Save
        </.button>
      </div>
    </form>
    <.table id="cities" rows={@streams.cities}>
      <:col :let={{_id, city}} label="Name">
        {city.name}
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-zinc-700">{city.district}</dd>
        </dl>
        <dl class="hidden md:block font-normal text-xs text-zinc-400">
          <dt>Stream inserted:</dt>
          <dd>{Timex.now()}</dd>
        </dl>
      </:col>
      <:col :let={{_id, city}} label="District" class="hidden md:table-cell">{city.district}</:col>
      <:col :let={{_id, city}} label="Population" class="text-right md:pr-10">
        {Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ")}
      </:col>
      <:action :let={{id, city}}>
        <.link phx-click={JS.push("delete", value: %{id: city.id}) |> hide("##{id}")} data-confirm="Are you sure?">
          <span class="hidden md:inline">Delete</span> <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/tabular_insert.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# tabularinsert" to="# endtabularinsert" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/tabular_insert.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("add-tabular-input", _, socket) do
    last_id = List.last(socket.assigns.tabular_input_ids, 0)
    new_id = last_id + 1

    # Create a new tabular input with a unique ID and empty form
    tabular_input = %{
      id: new_id,
      form: get_empty_form()
    }

    # Send message to add the new tabular input into stream
    send(self(), {:add_tabular_input, tabular_input})

    # Update the socket state with the new tabular input ID
    {:noreply, update(socket, :tabular_input_ids, &(&1 ++ [new_id]))}
  end

  def handle_event("remove-tabular-input", %{"id" => id}, socket) do
    id = String.to_integer(id)

    # Send message to remove the tabular input with the given ID from stream
    send(self(), {:remove_tabular_input, %{id: id}})

    # Update the socket state by removing the tabular input ID
    {:noreply, update(socket, :tabular_input_ids, &List.delete(&1, id))}
  end

  def handle_event("save", %{"city" => tabular_params}, socket) do
    city_params = get_city_params(socket.assigns.tabular_input_ids, tabular_params)

    # Validate each set of city parameters
    validations =
      for {id, params} <- city_params do
        changeset =
          %City{}
          |> Cities.change_city(params)
          |> Map.put(:action, :validate)

        tabular_input = %{
          id: id,
          form: to_form(changeset)
        }

        # Send message to update tabular input with validation results within stream
        send(self(), {:add_tabular_input, tabular_input})

        changeset.valid?
      end

    # If all validations pass, save the cities and clear the inputs
    if Enum.all?(validations) do
      for {id, params} <- city_params do
        Cities.create_city_broadcast(params)
        send(self(), {:remove_tabular_input, %{id: id}})
      end

      {:noreply, assign(socket, :tabular_input_ids, [])}
    else
      {:noreply, socket}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    city = Cities.get_city!(id)
    {:ok, _} = Cities.delete_city_broadcast(city)

    {:noreply, socket}
  end

  def handle_info({:add_tabular_input, tabular_input}, socket) do
    {:noreply, stream_insert(socket, :tabular_inputs, tabular_input)}
  end

  def handle_info({:remove_tabular_input, tabular_input}, socket) do
    # Remove the tabular input from the stream using a map with the key %{id: id}
    # Note: stream_delete/3 does not necessarily assume an ID; it simply requires
    # a unique identifier to locate and remove the element from the stream.
    # Example: If the stream contains a list of maps with keys :code, :firstname, and :lastname,
    # you can remove an entry by specifying the unique :code value
    # Example usage: stream_delete(socket, :persons, %{code: unique_code})
    {:noreply, stream_delete(socket, :tabular_inputs, tabular_input)}
  end

  def handle_info({:create_city, city}, socket) do
    {:noreply, stream_insert(socket, :cities, city, at: 0)}
  end

  def handle_info({:delete_city, city}, socket) do
    {:noreply, stream_delete(socket, :cities, city)}
  end

  defp get_city_params(tabular_input_ids, tabular_params) do
    # Converts a map received from multiple inputs into a list of tuples that can be used to validate and save data.
    #
    # ## Parameters
    #
    #   - tabular_input_ids: List of IDs representing the added (and not removed) tabular inputs.
    #   - tabular_params: Map received from tabular inputs in the save event (from inputs where `multiple={true}`).
    #
    # ## Example
    #
    #     iex> tabular_input_ids = [2, 5]
    #     iex> tabular_params = %{
    #       "name" => ["Tallinn", "Tartu"],
    #       "district" => ["Tartu Maakond", "Harju Maakond"],
    #       "population" => ["101 246", "403 981"]
    #     }
    #     iex> get_city_params(tabular_input_ids, tabular_params)
    #     [
    #       {2, %{"name" => "Tartu", "district" => "Tartu Maakond", "population" => "101 246", "countrycode" => "EST"}},
    #       {5, %{"name" => "Tallinn", "district" => "Harju Maakond", "population" => "403 981", "countrycode" => "EST"}}
    #     ]
    #
    for {id, index} <- Enum.with_index(tabular_input_ids) do
      params =
        Enum.reduce(tabular_params, %{}, fn {k, v}, acc -> Map.put(acc, k, Enum.at(v, index)) end)
        |> Map.put("countrycode", @countrycode)

      {id, params}
    end
  end

  defp get_empty_form() do
    %City{}
    |> Cities.change_city()
    |> to_form()
  end
end
