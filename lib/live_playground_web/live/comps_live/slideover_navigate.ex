defmodule LivePlaygroundWeb.CompsLive.SlideoverNavigate do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Slideover with Navigation
      <:subtitle>
        Adding Navigation to Slideovers in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def slideover">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show_slideover("with-navigate-button")}>
      Show slideover
    </.button_link>
    <.slideover id="with-navigate-button" on_confirm={JS.navigate(~p"/modal-navigate")}>
      <:title>With navigate button</:title>
      Navigate to modal
      <:confirm>Go</:confirm>
    </.slideover>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/slideover_navigate.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
