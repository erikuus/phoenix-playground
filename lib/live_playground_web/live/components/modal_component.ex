defmodule LivePlaygroundWeb.Components.ModalComponent do
  use LivePlaygroundWeb, :live_component

  def render(assigns) do
    ~L"""
      <div class="phx-modal"
        phx-capture-click="close"
        phx-window-keyup="close"
        phx-key="escape"
        phx-target="<%= @myself %>">
        <div class="phx-modal-content">
          <%= live_patch raw("&times;"), to: @return_to %>
          <%= live_component(@component, @opts) %>
        </div>
      </div>
    """
  end

  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
