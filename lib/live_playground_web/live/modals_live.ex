defmodule LivePlaygroundWeb.ModalsLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent
  import LivePlaygroundWeb.LiveHelpers

  alias LivePlaygroundWeb.Live.ModalContent

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.heading>
      Modals
      <:footer>
       How to open modals in live view
      </:footer>
    </.heading>
    <!-- end hiding from live code -->
    <div class="space-x-0 space-y-3 xl:space-x-3 xl:space-y-0">
      <.button patch={Routes.modals_path(@socket, :modal_a)} class="w-full xl:w-auto">Confirm Return</.button>
      <.button patch={Routes.modals_path(@socket, :modal_b)} class="w-full xl:w-auto">Confirm Proceed</.button>
      <.button patch={Routes.modals_path(@socket, :modal_c)} class="w-full xl:w-auto">Confirm Action</.button>
    </div>
    <%= show_live_modal(@socket, @live_action) %>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/modals_live.ex")) %>
      <%= raw(code("lib/live_playground_web/helpers/live_helpers.ex", "def live_modal", "end")) %>
      <%= raw(code("lib/live_playground_web/live/components/modal_component.ex")) %>
      <%= raw(code("lib/live_playground_web/live/components/modal_content/single_action_component.ex")) %>
      <%= raw(code("lib/live_playground_web/router.ex", "# modals", "#", :router)) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp show_live_modal(socket, :modal_a) do
    live_modal(:confirm_return,
      title: "Payment successful",
      description: lorem_ipsum_sentences(2),
      return_text: "Continue shopping",
      return_to: Routes.live_path(socket, __MODULE__)
    )
  end

  defp show_live_modal(socket, :modal_b) do
    live_modal(:confirm_go_to,
      title: "Added to Cart",
      description: lorem_ipsum_sentences(4),
      go_text: "Proceed to checkout",
      go_to: Routes.modals_path(socket, :modal_c),
      return_text: "Continue shopping",
      return_to: Routes.live_path(socket, __MODULE__)
    )
  end

  defp show_live_modal(socket, :modal_c) do
    live_modal(
      ModalContent.GrayFooterComponent,
      [
        title: "Deactivate account",
        description: lorem_ipsum_sentences(3),
        go_to: Routes.modals_path(socket, :modal_a),
        return_to: Routes.live_path(socket, __MODULE__)
      ],
      %{capture_close: false, show_close_btn: true}
    )
  end

  defp show_live_modal(_, _), do: nil
end
