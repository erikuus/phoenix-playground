defmodule LivePlaygroundWeb.ModalsLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.LiveHelpers

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Modals
      <:subtitle>
        How to open modals in live view
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 lg:flex-row lg:space-x-3 lg:space-y-0">
      <.button_link patch={~p"/modals/modal-a"}>
        Confirm return
      </.button_link>
      <.button_link patch={~p"/modals/modal-b"}>
        Confirm proceed
      </.button_link>
      <.button_link patch={~p"/modals/modal-c"}>
        Confirm action
      </.button_link>
      <.button_link patch={~p"/modals/modal-d"}>
        Live component
      </.button_link>
    </div>
    <%= show_live_modal(@live_action) %>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/modals_live.ex")) %>
      <%= raw(code("lib/live_playground_web/helpers/live_helpers.ex")) %>
      <%= raw(code("lib/live_playground_web/live/components/modal_component.ex")) %>
      <%= raw(code("lib/live_playground_web/live/components/text_component.ex")) %>
      <%= raw(code("lib/live_playground_web/router.ex", "# modals", "# endmodals", :router)) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp show_live_modal(:modal_a) do
    live_modal(:confirm_return,
      title: "Payment successful",
      description: lorem_ipsum_sentences(2),
      return_text: "Continue shopping",
      return_to: ~p"/modals"
    )
  end

  defp show_live_modal(:modal_b) do
    live_modal(:confirm_proceed,
      title: "Added to Cart",
      description: lorem_ipsum_sentences(4),
      proceed_text: "Proceed to checkout",
      proceed_to: ~p"/modals/modal-c",
      return_text: "Continue shopping",
      return_to: ~p"/modals"
    )
  end

  defp show_live_modal(:modal_c) do
    live_modal(:confirm_action,
      title: "Deactivate account",
      description: lorem_ipsum_sentences(4),
      action_text: "Deactivate",
      action_to: ~p"/modals/modal-d",
      return_text: "Cancel",
      return_to: ~p"/modals"
    )
  end

  defp show_live_modal(:modal_d) do
    live_modal(
      LivePlaygroundWeb.Components.TextComponent,
      [
        heading: "Lorem ipsum",
        content: lorem_ipsum_paragraphs(3),
        return_to: ~p"/modals"
      ],
      %{capture_close: false, show_close_btn: true}
    )
  end

  defp show_live_modal(_), do: nil
end
