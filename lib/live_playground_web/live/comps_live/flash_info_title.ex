defmodule LivePlaygroundWeb.CompsLive.FlashInfoTitle do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Flash Info with Title
      <:subtitle>
        How to Display the Flash Message as an Information
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def flash">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show("#info-with-title")}>
      Show flash
    </.button_link>
    <.flash id="info-with-title" kind={:info} autoshow={false} title="Info with title">
      <%= placeholder_sentences(3, true) %>
    </.flash>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/flash_info_title.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
