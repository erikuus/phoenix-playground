defmodule LivePlaygroundWeb.ClicksLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        title: "Clicks",
        description: "How to handle clicks in live view",
        input_values: [],
        input_fields: [],
        current_index: 0
      )

    {:ok, socket, temporary_assigns: [input_fields: []]}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <%= render_partial(@live_action, assigns) %>

    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/router.ex",
        "    live \"/clicks\", ClicksLive",
        "    live \"/clicks/show-list\", ClicksLive, :show_list")) %>
      <%= raw(code("lib/live_playground_web/live/clicks_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp render_partial(:show_list, assigns) do
    ~H"""
    <ul role="list" class="mb-4 divide-y divide-gray-200">
    <%= for input_value <- @input_values do  %>
      <li class="py-4"><%= input_value %></li>
    <% end %>
    </ul>
    <%= live_patch "Reset",
      to: Routes.live_path(@socket, __MODULE__),
      class: tw_button_classes(:primary) %>
    """
  end

  defp render_partial(_, assigns) do
    ~H"""
    <form id="input-fields-form" phx-submit="show-list">
      <div id="input-fields" phx-update="append">
      <%= for input_field <- @input_fields do  %>
        <%= raw(input_field) %>
      <% end %>
      </div>
      <button type="button" class={"#{tw_button_classes(:secondary)}"} phx-click="add-input">
        Add field
      </button>
      <%= if @current_index > 0 do %>
        <button type="submit" class={"#{tw_button_classes(:primary)} ml-2"}>
          Show list
        </button>
      <% end %>
    </form>
    """
  end

  def handle_event("add-input", _, socket) do
    index = socket.assigns.current_index
    socket = update(socket, :input_fields, &[input_field(:add, index) | &1])
    socket = update(socket, :current_index, &(&1 + 1))
    {:noreply, socket}
  end

  def handle_event("remove-input", %{"index" => index}, socket) do
    socket = update(socket, :input_fields, &[input_field(:remove, index) | &1])
    {:noreply, socket}
  end

  def handle_event("show-list", %{"texts" => texts}, socket) do
    socket =
      assign(socket,
        input_values: texts,
        input_fields: [],
        current_index: 0
      )

    {:noreply, push_patch(socket, to: Routes.clicks_path(socket, :show_list))}
  end

  defp input_field(:add, index) do
    """
    <div id="field#{index}" class="mb-4">
      <label for="text#{index}" class="#{tw_label_classes()}">Text</label>
      <div class="mt-1 flex space-x-2">
        <input type="text" name="texts[]" id="text#{index}" class="#{tw_input_classes()}" value="#{lorem_ipsum_sentences(1, true)}">
        <button type="button" class="#{tw_button_classes(:secondary)}" phx-click="remove-input" phx-value-index="#{index}">
          Remove
        </button>
      </div>
    </div>
    """
  end

  defp input_field(:remove, index) do
    """
    <div id="field#{index}"></div>
    """
  end
end
