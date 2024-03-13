defmodule LivePlaygroundWeb.CompsLive.ModalNavigate do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Modal with Navigation
      <:subtitle>
        How to Add Navigation Functionality to Modal
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def modal">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show_modal("with-navigate-button")}>
      Show modal
    </.button_link>
    <.modal id="with-navigate-button" on_confirm={JS.navigate(~p"/slideover")}>
      <:title>With navigate button</:title>
      Navigate to slideover
      <:confirm>Go</:confirm>
    </.modal>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/modal_navigate.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
