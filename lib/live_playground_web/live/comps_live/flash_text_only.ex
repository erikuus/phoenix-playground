defmodule LivePlaygroundWeb.CompsLive.FlashTextOnly do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Flash with Text Only
      <:subtitle>
        How to Display the Flash Message without a Title
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def flash">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show("#text-only-info")}>
      Show flash
    </.button_link>
    <.flash id="text-only-info" kind={:info} autoshow={false}>
      <%= placeholder_sentences(3, true) %>
    </.flash>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/flash_text_only.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
