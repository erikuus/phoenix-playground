defmodule LivePlaygroundWeb.ModalsLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlaygroundWeb.Components

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        title: "Modals",
        description: "How to open modals in live view"
      )

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="mt-10 space-x-4">
      <%= live_patch("Centered with single action",
          to: Routes.modals_path(@socket, :single_action),
          class: tw_button_classes(:secondary)
        ) %>
    </div>
    <%= if @live_action == :single_action do %>
      <%= live_modal Components.SingleActionComponent,
        return_to: Routes.live_path(@socket, __MODULE__),
        close_btn: false %>
    <% end %>
    """
  end
end
