defmodule LivePlaygroundWeb.CompsLive.ModalRed do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :modal, nil)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Modal in Red
      <:subtitle>
        Designing Red-Themed Modals in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def modal">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show_modal("with-red-button")}>
      Show modal
    </.button_link>
    <.modal id="with-red-button" on_confirm={JS.push("ok", value: %{modal: "With red button"}) |> hide_modal("with-red-button")}>
      <:icon>
        <div class="rounded-full bg-red-100 p-3">
          <.icon name="hero-exclamation-triangle" class="h-6 w-6 text-red-600" />
        </div>
      </:icon>
      <:title>With red button</:title>
      <%= placeholder_sentences(3) %>
      <:confirm class="bg-red-600 hover:bg-red-700">OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>
    <.alert :if={@modal} kind={:success} class="mt-6">
      Modal "<%= @modal %>" confirmed!
    </.alert>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/modal_red.ex" />
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
