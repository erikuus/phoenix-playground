defmodule LivePlaygroundWeb.CompsLive.FlashErrorTitle do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Flash Error with Title
      <:subtitle>
        How to Display the Flash Message as an Error
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def flash">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show("#error-with-title")}>
      Show flash
    </.button_link>
    <.flash id="error-with-title" kind={:error} autoshow={false} title="Error with title">
      <%= placeholder_sentences(3, true) %>
    </.flash>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/flash_error_title.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("set-flash", %{"msg" => msg}, socket) do
    {:noreply, put_flash(socket, :info, msg)}
  end
end
