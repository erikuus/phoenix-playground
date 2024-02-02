defmodule LivePlaygroundWeb.CompsLive.FlashErrorWoClose do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Flash without Close Button
      <:subtitle>
        How to Display the Flash Message without a Close Button
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def flash">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show("#error-without-close")}>
      Show flash
    </.button_link>
    <.flash id="error-without-close" kind={:error} autoshow={false} close={false} title="Error without close button">
      <%= placeholder_sentences(3, true) %>
    </.flash>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/flash_error_wo_close.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
