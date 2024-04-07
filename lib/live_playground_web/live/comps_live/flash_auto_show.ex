defmodule LivePlaygroundWeb.CompsLive.FlashAutoShow do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Flash Auto Show
      <:subtitle>
        Configuring Flash Messages for Automatic Display in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def flash">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.flash kind={:info} title="Autoshow info">
      <%= placeholder_sentences(3, true) %>
    </.flash>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/flash_auto_show.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
