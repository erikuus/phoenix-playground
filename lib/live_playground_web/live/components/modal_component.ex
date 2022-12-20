defmodule LivePlaygroundWeb.Components.ModalComponent do
  use LivePlaygroundWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="relative z-10 hover:bg-red-500" aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
      <div class="fixed inset-0 z-10 overflow-y-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
          phx-capture-click="close"
          phx-window-keyup="close"
          phx-key="escape"
          phx-target={"#{@myself}"}>
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:p-0">
            <%= if @close_opts.show_close_btn do %>
            <div class="absolute top-0 right-0 hidden pt-4 pr-4 sm:block">
              <%= live_patch raw(svg_icon_close("h-6 w-6")),
                class: tw_icon_classes(),
                to: @return_to
                 %>
            </div>
            <% end %>
            <%= live_component(@component, @opts) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("close", _, socket) do
    socket =
      if socket.assigns.close_opts.capture_close do
        push_patch(socket, to: socket.assigns.return_to)
      else
        socket
      end

    {:noreply, socket}
  end
end
