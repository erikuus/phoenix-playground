defmodule LivePlaygroundWeb.ClicksLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        tabular_values: [],
        tabular_fields: [],
        counter: 0,
        index: 0
      )

    {:ok, socket, temporary_assigns: [tabular_fields: []]}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.heading>
      Clicks
      <:footer>
      How to handle clicks in live view
      </:footer>
    </.heading>
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
    <.ul class="mb-4">
      <li :for={tabular_value <- @tabular_values} class="p-4"><%= tabular_value %></li>
    </.ul>
    <.button patch={Routes.live_path(@socket, __MODULE__)}>Reset</.button>
    """
  end

  defp render_action(_, assigns) do
    ~H"""
    <form id="tabular-form" phx-submit="show-list">
      <div :for={tabular_field <- @tabular_fields} id="tabular-fields" phx-update="append">
        <%= render_tabular_field(tabular_field) %>
      </div>
      <div class="space-x-2">
        <.button type="button" phx-click="add-input" color={:secondary} :if={@counter < 5}>Add field</.button>
        <.button type="submit" :if={@counter > 0}>Show list</.button>
      </div>
    </form>
    """
  end

  defp render_tabular_field(%{operation: :add} = assigns) do
    ~H"""
    <div id={"tabular-field-#{@index}"} class="mb-4 flex space-x-2">
      <.input name="texts[]" type="text" value={lorem_ipsum_sentences(1, true)} />
      <.button type="button" color={:secondary} phx-click="remove-input" phx-value-index={@index}>Remove</.button>
    </div>
    """
  end

  defp render_tabular_field(%{operation: :remove} = assigns) do
    ~H"""
    <div id={"tabular-field-#{@index}"}></div>
    """
  end

  def handle_event("add-input", _, socket) do
    index = socket.assigns.index
    socket = update(socket, :tabular_fields, &[%{index: index, operation: :add} | &1])
    socket = update(socket, :counter, &(&1 + 1))
    socket = update(socket, :index, &(&1 + 1))

    {:noreply, socket}
  end

  def handle_event("remove-input", %{"index" => index}, socket) do
    socket = update(socket, :tabular_fields, &[%{index: index, operation: :remove} | &1])
    socket = update(socket, :counter, &(&1 - 1))
    {:noreply, socket}
  end

  def handle_event("show-list", %{"texts" => texts}, socket) do
    socket =
      assign(socket,
        tabular_values: texts,
        tabular_fields: [],
        counter: 0,
        index: 0
      )

    {:noreply, push_patch(socket, to: Routes.clicks_path(socket, :show_list))}
  end
end
