defmodule LivePlaygroundWeb.ClicksLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        tabular_outputs: [],
        tabular_inputs: [],
        counter: 0,
        index: 0
      )

    {:ok, socket, temporary_assigns: [tabular_inputs: []]}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Clicks
      <:subtitle>
        How to handle clicks in live view
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <%= render_action(@live_action, assigns) %>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/clicks_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp render_action(:show_list, assigns) do
    ~H"""
    <.simple_list class="mb-4">
      <:item :for={value <- @tabular_outputs}><%= value %></:item>
    </.simple_list>
    <.button_link type="secondary" patch={~p"/clicks"}>
      Reset
    </.button_link>
    """
  end

  defp render_action(_, assigns) do
    ~H"""
    <form id="tabular-form" phx-submit="show-list">
      <div id="tabular-fields" phx-update="append">
        <.tabular_input :for={input <- @tabular_inputs} index={input.index} action={input.action} />
      </div>
      <div class="space-x-2">
        <.button :if={@counter < 5} type="button" phx-click="add-input">
          Add input
        </.button>
        <.button :if={@counter > 0} type="submit">
          Output values
        </.button>
      </div>
    </form>
    """
  end

  defp tabular_input(%{action: :add} = assigns) do
    ~H"""
    <div id={"input-#{@index}"} class="mb-4 flex space-x-2">
      <.input name="texts[]" value={lorem_ipsum_sentences(1, true)} />
      <.button type="button" phx-click="remove-input" phx-value-index={@index}>
        Remove
      </.button>
    </div>
    """
  end

  defp tabular_input(%{action: :remove} = assigns) do
    ~H"""
    <div id={"input-#{@index}"}></div>
    """
  end

  def handle_event("add-input", _, socket) do
    index = socket.assigns.index
    socket = update(socket, :tabular_inputs, &[%{index: index, action: :add} | &1])
    socket = update(socket, :counter, &(&1 + 1))
    socket = update(socket, :index, &(&1 + 1))

    {:noreply, socket}
  end

  def handle_event("remove-input", %{"index" => index}, socket) do
    socket = update(socket, :tabular_inputs, &[%{index: index, action: :remove} | &1])
    socket = update(socket, :counter, &(&1 - 1))
    {:noreply, socket}
  end

  def handle_event("show-list", %{"texts" => texts}, socket) do
    socket =
      assign(socket,
        tabular_outputs: texts,
        tabular_inputs: [],
        counter: 0,
        index: 0
      )

    {:noreply, push_patch(socket, to: ~p"/clicks/show-list")}
  end
end
