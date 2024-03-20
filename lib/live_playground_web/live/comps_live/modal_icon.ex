defmodule LivePlaygroundWeb.CompsLive.ModalIcon do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :modal, nil)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Modal with Icon
      <:subtitle>
        How to Add Icon to Modal
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def modal">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show_modal("with-icon")}>
      Show modal
    </.button_link>
    <.modal id="with-icon" on_confirm={JS.push("ok", value: %{modal: "With icon"}) |> hide_modal("with-icon")}>
      <:icon><.icon name="hero-exclamation-triangle" class="h-10 w-10 text-yellow-500" /></:icon>
      <:title>With icon</:title>
      <%= placeholder_sentences(3) %>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>
    <.alert :if={@modal} kind={:success} class="mt-6">
      Modal "<%= @modal %>" confirmed!
    </.alert>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/modal_icon.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("ok", %{"modal" => modal}, socket) do
    Process.send_after(self(), :reset, 2000)
    {:noreply, assign(socket, :modal, modal)}
  end

  def handle_info(:reset, socket) do
    {:noreply, assign(socket, :modal, nil)}
  end
end
