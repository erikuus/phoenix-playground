defmodule LivePlaygroundWeb.RecipesLive.TabularInsert do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  @countrycode "EST"
  @max_tabular_inputs 5

  def mount(_params, _session, socket) do
    if connected?(socket), do: Cities.subscribe()

    socket =
      socket
      |> assign(:max_tabular_inputs, @max_tabular_inputs)
      |> assign(:tabular_input_ids, [])
      |> stream(:tabular_inputs, [])
      |> stream(:cities, Cities.list_country_city(@countrycode))

    {:ok, socket}
  end

  def terminate(_reason, _socket) do
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
    <form phx-submit="save" class="space-y-2 md:space-y-4">
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
          <div class="flex-none text-right">
            <.link
              phx-click="remove-tabular-input"
              phx-value-id={tabular_input.id}
              class="rounded-full inline-flex items-center p-3 bg-zinc-100 hover:bg-zinc-200"
            >
              <.icon name="hero-minus-mini" class="h-5 w-5" />
            </.link>
          </div>
        </div>
      </div>
      <div class="flex items-center justify-between">
        <span>
          <.button :if={Enum.count(@tabular_input_ids) > 0} type="submit">
            Save
          </.button>
        </span>
        <span>
          <.link
            :if={Enum.count(@tabular_input_ids) < @max_tabular_inputs}
            phx-click="add-tabular-input"
            class="rounded-full inline-flex items-center p-3 bg-zinc-100 hover:bg-zinc-200"
          >
            <.icon name="hero-plus-mini" class="h-5 w-5" />
          </.link>
        </span>
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
    # Defensive guard in case the client bypasses UI constraints
    if length(socket.assigns.tabular_input_ids) >= socket.assigns.max_tabular_inputs do
      {:noreply, socket}
    else
      last_id = List.last(socket.assigns.tabular_input_ids, 0)
      new_id = last_id + 1

      tabular_input = %{
        id: new_id,
        form: get_empty_form()
      }

      socket =
        socket
        |> stream_insert(:tabular_inputs, tabular_input)
        |> update(:tabular_input_ids, &(&1 ++ [new_id]))

      {:noreply, socket}
    end
  end

  def handle_event("remove-tabular-input", %{"id" => id}, socket) do
    id = to_integer(id)

    socket =
      socket
      |> stream_delete(:tabular_inputs, %{id: id})
      |> update(:tabular_input_ids, &List.delete(&1, id))

    {:noreply, socket}
  end

  def handle_event("save", %{"city" => tabular_params}, socket) do
    city_params = convert_params(socket.assigns.tabular_input_ids, tabular_params)

    socket =
      Enum.reduce(city_params, socket, fn {id, params}, acc ->
        case Cities.create_city_broadcast(params) do
          {:ok, city} ->
            acc
            |> stream_delete(:tabular_inputs, %{id: id})
            |> stream_insert(:cities, city, at: 0)
            |> update(:tabular_input_ids, &List.delete(&1, id))
            |> put_flash(:info, "City record(s) added.")

          {:error, %Ecto.Changeset{} = changeset} ->
            # If creation failed, push the changeset back into the tabular input stream so the user can fix it
            tabular_input = %{id: id, form: to_form(changeset)}
            stream_insert(acc, :tabular_inputs, tabular_input)
        end
      end)

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    city = Cities.get_city!(to_integer(id))
    {:ok, _} = Cities.delete_city_broadcast(city)

    {:noreply, stream_delete(socket, :cities, city)}
  end

  def handle_info({LivePlayground.Cities, {:create_city, city}}, socket) do
    socket =
      socket
      |> stream_insert(:cities, city, at: 0)
      |> put_flash(:info, "City record(s) added by another user.")

    {:noreply, socket}
  end

  def handle_info({LivePlayground.Cities, {:delete_city, city}}, socket) do
    {:noreply, stream_delete(socket, :cities, city)}
  end

  defp get_empty_form() do
    %City{}
    |> Cities.change_city()
    |> to_form()
  end

  defp to_integer(value) when is_integer(value), do: value

  defp to_integer(value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} -> i
      _ -> 0
    end
  end

  defp convert_params(tabular_input_ids, tabular_params) do
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
    #     iex> convert_params(tabular_input_ids, tabular_params)
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
end
