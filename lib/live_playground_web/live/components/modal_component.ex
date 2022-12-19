defmodule LivePlaygroundWeb.Components.ModalComponent do
  use LivePlaygroundWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="phx-modal"
        phx-capture-click="close"
        phx-window-keyup="close"
        phx-key="escape"
        phx-target={"#{@myself}"}>
        <div class={"phx-modal-content #{tw_modal_content_classes()}"}>
          <%= if @close_btn do %>
            <%= live_patch raw(svg_icon_close()),
              to: @return_to,
              class: "phx-modal-close" %>
          <% end %>
          <%= live_component(@component, @opts) %>
        </div>
      </div>
    """
  end

  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
