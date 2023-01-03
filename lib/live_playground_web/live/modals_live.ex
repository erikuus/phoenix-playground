defmodule LivePlaygroundWeb.ModalsLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlaygroundWeb.Live.ModalContent

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
    ~H"""
    <div class="my-10 space-x-0 space-y-3 xl:space-x-3 xl:space-y-0">
      <%= open_modal_btn("Centered with single action", @socket, :single_action) %>
      <%= open_modal_btn("Centered with wide buttons", @socket, :wide_buttons) %>
      <%= open_modal_btn("Left-aligned buttons", @socket, :left_buttons) %>
      <%= open_modal_btn("Right-aligned buttons", @socket, :right_buttons) %>
      <%= open_modal_btn("Gray footer", @socket, :gray_footer) %>
    </div>

    <%= show_live_modal(@socket, @live_action) %>

    <!-- start hiding from live code -->
    <div class="space-y-6">
      <%= raw(live_code("lib/live_playground_web/helpers/live_helpers.ex", "def live_modal", "end")) %>
      <%= raw(live_code("lib/live_playground_web.ex", "def live_component", "end")) %>
      <%= raw(live_code("lib/live_playground_web/live/components/modal_component.ex")) %>
      <%= raw(live_code("lib/live_playground_web.ex", "def live_view", "end")) %>
      <%= raw(live_code("lib/live_playground_web/router.ex", "scope \"/\", LivePlaygroundWeb", "end")) %>
      <%= raw(live_code("lib/live_playground_web/live/modals_live.ex")) %>
      <%= raw(live_code("lib/live_playground_web/live/components/modal_content/single_action_component.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp open_modal_btn(text, socket, action) do
    live_patch(text,
      to: Routes.modals_path(socket, action),
      class: "w-full xl:w-auto #{tw_button_classes()}"
    )
  end

  defp show_live_modal(socket, :single_action) do
    live_modal(ModalContent.SingleActionComponent,
      title: "Payment successful",
      description: lorem_ipsum_sentences(2),
      return_to: Routes.live_path(socket, __MODULE__)
    )
  end

  defp show_live_modal(socket, :wide_buttons) do
    live_modal(ModalContent.WideButtonsComponent,
      title: "Payment successful",
      description: lorem_ipsum_sentences(4),
      go_to: Routes.modals_path(socket, :left_buttons),
      return_to: Routes.live_path(socket, __MODULE__)
    )
  end

  defp show_live_modal(socket, :left_buttons) do
    live_modal(ModalContent.LeftButtonsComponent,
      title: "Deactivate account",
      description: lorem_ipsum_sentences(3),
      go_to: Routes.modals_path(socket, :right_buttons),
      return_to: Routes.live_path(socket, __MODULE__)
    )
  end

  defp show_live_modal(socket, :right_buttons) do
    live_modal(ModalContent.RightButtonsComponent,
      title: "Deactivate account",
      description: lorem_ipsum_sentences(3),
      go_to: Routes.modals_path(socket, :gray_footer),
      return_to: Routes.live_path(socket, __MODULE__)
    )
  end

  defp show_live_modal(socket, :gray_footer) do
    live_modal(
      ModalContent.GrayFooterComponent,
      [
        title: "Deactivate account",
        description: lorem_ipsum_sentences(3),
        go_to: Routes.modals_path(socket, :single_action),
        return_to: Routes.live_path(socket, __MODULE__)
      ],
      %{capture_close: false, show_close_btn: true}
    )
  end

  defp show_live_modal(_, _), do: nil
end
