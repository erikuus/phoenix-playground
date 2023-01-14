defmodule LivePlaygroundWeb.ChangesLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        title: "Changes",
        description: "How to handle form changes in live view",
        type: "2"
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <form id="dynamic-form">
      <div class="mb-4">
        <label for="type" class={"#{tw_label_classes()}"}>Text</label>
        <div class="mt-1">
          <select id="type" name="type" phx-change="select-type" class={"#{tw_input_classes()}"}>
            <%= options_for_select(type_options(), @type) %>
          </select>
        </div>
      </div>
      <%= render_partial(:type, @type, assigns) %>
      <div class="mb-4 space-y-4">
        <div class="flex items-center">
          <input id="card" name="payment-method" type="radio" class={"#{tw_radio_classes()}"}>
          <label for="card" class={"#{tw_label_classes()}"}>Credit Card</label>
        </div>
        <div class="flex items-center">
          <input id="invoice" name="payment-method" type="radio" class={"#{tw_radio_classes()}"}>
          <label for="invoice" class={"#{tw_label_classes()}"}>Invoice</label>
        </div>
        <div class="flex items-center">
          <input id="cash" name="payment-method" type="radio" class={"#{tw_radio_classes()}"}>
          <label for="cash" class={"#{tw_label_classes()}"}>Cash</label>
        </div>
      </div>
    </form>
    """
  end

  defp render_partial(:type, "1", assigns) do
    ~H"""
    type 1
    """
  end

  defp render_partial(:type, "2", assigns) do
    ~H"""
    type 2
    """
  end

  defp render_partial(_, _, _), do: nil

  def handle_event("select-type", %{"type" => type}, socket) do
    socket = assign(socket, type: type)
    {:noreply, socket}
  end

  defp type_options do
    [
      A: 1,
      B: 2,
      C: 3
    ]
  end
end
