defmodule LivePlaygroundWeb.CompsLive.AlertPutFlash do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Alert Using Put Flash
      <:subtitle>
        Triggering Alert with put_flash Message in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def alert">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="space-y-3">
      <.alert flash={@flash} flash_key={:breaking_news} title="Breaking News" icon="hero-exclamation-triangle-mini" kind={:error} />
      <.button_link phx-click={JS.push("set-flash")}>
        Show breaking news
      </.button_link>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/alert_put_flash.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("set-flash", _, socket) do
    msg = placeholder_sentences(3, true)
    {:noreply, put_flash(socket, :breaking_news, msg)}
  end
end
