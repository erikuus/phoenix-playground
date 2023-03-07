defmodule LivePlaygroundWeb.Live.ModalComponent do
  use LivePlaygroundWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      class="relative z-10 hover:bg-red-500"
      aria-labelledby="modal-title"
      role="dialog"
      aria-modal="true"
    >
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
      <div class="fixed inset-0 z-10 overflow-y-auto">
        <div
          phx-capture-click="close"
          phx-window-keyup="close"
          phx-key="escape"
          phx-target={@myself}
          class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
        >
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:p-0">
            <div
              :if={@close_opts.show_close_btn}
              class="absolute top-0 right-0 hidden pt-4 pr-4 sm:block"
            >
              <.link patch={@return_to}>
                <svg
                  class="w-6 h-6 text-gray-400 hover:text-gray-500"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </.link>
            </div>
            <%= if is_confirm_component(@component) do %>
              <UiComponent.confirm type={@component} opts={Enum.into(@opts, %{})} />
            <% else %>
              <%= live_component(@component, @opts) %>
            <% end %>
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

  defp is_confirm_component(component) do
    if component in [:confirm_return, :confirm_proceed, :confirm_action], do: true, else: false
  end
end
