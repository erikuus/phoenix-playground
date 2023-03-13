defmodule LivePlaygroundWeb.ModalsAdvancedLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.LiveHelpers

  alias LivePlaygroundWeb.Components

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
      Advanced Modals
      <:subtitle>
        How to open live components in modals with routes
      </:subtitle>
      <:actions>
        <.link navigate={~p"/modals"}>
          Back to core modals
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 lg:flex-row lg:space-x-3 lg:space-y-0">
      <.button_link patch={~p"/modals-advanced/text"}>
        Text Component
      </.button_link>
      <.button_link patch={~p"/modals-advanced/math"}>
        Math Component
      </.button_link>
      <.button_link patch={~p"/modals-advanced/image"}>
        Image Component
      </.button_link>
    </div>
    <%= show_live_modal(@live_action) %>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/modals_advanced_live.ex")) %>
      <%= raw(code("lib/live_playground_web/helpers/live_helpers.ex")) %>
      <%= raw(code("lib/live_playground_web/live/components/modal_component.ex")) %>
      <%= raw(code("lib/live_playground_web/live/components/text_component.ex")) %>
      <%= raw(code("lib/live_playground_web/router.ex", "# modals", "# endmodals", :router)) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp show_live_modal(:text) do
    live_modal(Components.TextComponent,
      id: :text,
      title: "Text Component",
      content: lorem_ipsum_paragraphs(3, true),
      proceed_text: "Proceed to Math Component",
      proceed_to: ~p"/modals-advanced/math",
      return_to: ~p"/modals-advanced"
    )
  end

  defp show_live_modal(:math) do
    live_modal(Components.MathComponent,
      id: :math,
      title: "Math Component",
      value: 10,
      proceed_text: "Proceed to Image Component",
      proceed_to: ~p"/modals-advanced/image",
      return_to: ~p"/modals-advanced"
    )
  end

  defp show_live_modal(:image) do
    live_modal(
      Components.ImageComponent,
      [
        heading: "Lorem ipsum",
        content: lorem_ipsum_paragraphs(3),
        return_text: "Close",
        return_to: ~p"/modals-advanced"
      ],
      %{capture_close: false, show_close_btn: true}
    )
  end

  defp show_live_modal(_), do: nil
end
