defmodule LivePlaygroundWeb.CompsLive.ButtonLink do
  use LivePlaygroundWeb, :live_view

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
      Button Link
      <:subtitle>
        How to Make Links Look Like Buttons
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def button_link">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 sm:flex-row sm:space-x-3 sm:space-y-0">
      <.button_link navigate={~p"/button-link"}>Default</.button_link>
      <.button_link patch={~p"/button-link"} kind={:secondary}>Secondary</.button_link>
      <.button_link href="/button-link" kind={:dangerous}>Dangerous</.button_link>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/button_link.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
