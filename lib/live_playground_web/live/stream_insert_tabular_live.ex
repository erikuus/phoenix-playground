defmodule LivePlaygroundWeb.StreamInsertTabularLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:tabular_inputs, [])
      |> assign(tabular_index: 0, tabular_counter: 0)

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
          <.button type="button" phx-click="remove-tabular-input" phx-value-id={id}>
            Remove
          </.button>
        </div>
      </div>
      <div class="space-x-2">
        <.button :if={@tabular_counter < 5} type="button" phx-click="add-tabular-input">
          Add
        </.button>
        <.button :if={@tabular_counter > 0} type="submit">
          Save
        </.button>
      </div>
    </form>
    """
  end

  def handle_event("add-tabular-input", _, socket) do
    tabular_input = %{
      id: socket.assigns.tabular_index,
      form: get_empty_form()
    }

    socket =
      socket
      |> stream_insert(:tabular_inputs, tabular_input)
      |> update(:tabular_index, &(&1 + 1))
      |> update(:tabular_counter, &(&1 + 1))

    {:noreply, socket}
  end

  def handle_event("remove-tabular-input", %{"id" => id}, socket) do
    socket =
      socket
      |> stream_delete_by_dom_id(:tabular_inputs, id)
      |> update(:tabular_counter, &(&1 - 1))

    {:noreply, socket}
  end

  def handle_event("validate", %{"city" => tabular_params}, socket) do
    IO.inspect(tabular_params)

    for x <- [0, 1] do
      form =
        %City{}
        |> Cities.change_city(%{})
        |> Map.put(:action, :validate)
        |> to_form()

      tabular_input = %{
        id: x,
        form: form
      }

      send(self(), {:stream_tabular_input, tabular_input})
    end

    {:noreply, socket}
  end

  def handle_info({:stream_tabular_input, tabular_input}, socket) do
    {:noreply, stream_insert(socket, :tabular_inputs, tabular_input)}
  end

  defp get_empty_form() do
    %City{}
    |> Cities.change_city()
    |> to_form()
  end
end
