defmodule LivePlaygroundWeb.StreamInsertTabularLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:tabular_inputs, [])
      |> assign(:tabular_input_ids, [])

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <form phx-submit="validate" class="space-y-4">
      <div id="tabular_inputs" phx-update="stream" class="space-y-4">
        <div
          :for={{id, tabular_input} <- @streams.tabular_inputs}
          id={id}
          class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0"
        >
          <.input field={tabular_input.form[:name]} id={"city_name_#{id}"} multiple={true} placeholder="Name" class="flex-auto" />
          <.input
            field={tabular_input.form[:district]}
            id={"city_district_#{id}"}
            multiple={true}
            placeholder="District"
            class="flex-auto"
          />
          <.input
            field={tabular_input.form[:population]}
            id={"city_population_#{id}"}
            multiple={true}
            placeholder="Population"
            class="flex-auto"
          />
          <div>
            <.button type="button" phx-click="remove-tabular-input" phx-value-id={tabular_input.id}>
              Remove
            </.button>
          </div>
        </div>
      </div>
      <div class="space-x-2">
        <.button :if={Enum.count(@tabular_input_ids) < 5} type="button" phx-click="add-tabular-input">
          Add
        </.button>
        <.button :if={Enum.count(@tabular_input_ids) > 0} type="submit">
          Save
        </.button>
        <%= inspect(@tabular_input_ids) %>
      </div>
    </form>
    """
  end

  def handle_event("add-tabular-input", _, socket) do
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

  def handle_event("remove-tabular-input", %{"id" => id}, socket) do
    socket =
      socket
      |> stream_delete(:tabular_inputs, %{id: id})
      |> update(:tabular_input_ids, &List.delete(&1, String.to_integer(id)))

    {:noreply, socket}
  end

  def handle_event("validate", %{"city" => tabular_params}, socket) do
    valid =
      for {id, index} <- Enum.with_index(socket.assigns.tabular_input_ids) do
        params =
          get_params(tabular_params, index)
          |> Map.put("countrycode", "EST")

        changeset =
          %City{}
          |> Cities.change_city(params)
          |> Map.put(:action, :validate)

        tabular_input = %{
          id: id,
          form: to_form(changeset)
        }

        send(self(), {:stream_tabular_input, tabular_input})

        changeset.valid?
      end

    if Enum.all?(valid), do: send(self(), {:save_tabular_params, tabular_params})

    {:noreply, socket}
  end

  def handle_info({:stream_tabular_input, tabular_input}, socket) do
    {:noreply, stream_insert(socket, :tabular_inputs, tabular_input)}
  end

  def handle_info({:save_tabular_params, _tabular_params}, socket) do
    {:noreply, push_patch(socket, to: ~p"/stream-insert-tabular")}
  end

  defp get_params(tabular_params, index) do
    Enum.reduce(tabular_params, %{}, fn {k, v}, acc -> Map.put(acc, k, Enum.at(v, index)) end)
  end

  defp get_empty_form() do
    %City{}
    |> Cities.change_city()
    |> to_form()
  end
end
