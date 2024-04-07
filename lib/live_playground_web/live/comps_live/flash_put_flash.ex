defmodule LivePlaygroundWeb.CompsLive.FlashPutFlash do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Flash Using Put Flash
      <:subtitle>
        Triggering Flash Messages with Events in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def flash">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={JS.push("set-flash", value: %{msg: placeholder_sentences(3, true)})}>
      Show flash
    </.button_link>
    <.flash id="flash-messages-info" kind={:info} flash={@flash} close={false} title="Flash messages info" />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/flash_put_flash.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("set-flash", %{"msg" => msg}, socket) do
    {:noreply, put_flash(socket, :info, msg)}
  end
end
