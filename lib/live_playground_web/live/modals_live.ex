defmodule LivePlaygroundWeb.ModalsLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :modal, nil)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Modals
      <:subtitle>
        How to display confirmation dialog using core modal component
      </:subtitle>
      <:actions>
        <.link navigate={~p"/modals-advanced"}>
          Try advanced modals
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 lg:flex-row lg:space-x-3 lg:space-y-0">
      <.button_link phx-click={show_modal("basic")}>
        Basic
      </.button_link>
      <.button_link phx-click={show_modal("with-subtitle")}>
        With subtitle
      </.button_link>
      <.button_link phx-click={show_modal("with-icon")}>
        With icon
      </.button_link>
      <.button_link phx-click={show_modal("with-red-button")}>
        With red button
      </.button_link>
      <.button_link phx-click={show_modal("with-navigate-button")}>
        With navigate button
      </.button_link>
    </div>

    <.alert :if={@modal} class="mt-6">
      Modal "<%= @modal %>" confirmed!
    </.alert>

    <.modal id="basic" on_confirm={JS.push("ok", value: %{modal: "Basic"}) |> hide_modal("basic")}>
      <:title>Basic</:title>
      <%= lorem_ipsum_sentences(3) %>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>

    <.modal id="with-subtitle" on_confirm={JS.push("ok", value: %{modal: "With subtitle"}) |> hide_modal("with-subtitle")}>
      <:title>With subtitle</:title>
      <:subtitle>Subtitle</:subtitle>
      <%= lorem_ipsum_sentences(3) %>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>

    <.modal id="with-icon" on_confirm={JS.push("ok", value: %{modal: "With icon"}) |> hide_modal("with-icon")}>
      <:icon><.icon name="hero-exclamation-triangle" class="h-10 w-10 text-yellow-500" /></:icon>
      <:title>With icon</:title>
      <%= lorem_ipsum_sentences(3) %>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>

    <.modal id="with-red-button" on_confirm={JS.push("ok", value: %{modal: "With red button"}) |> hide_modal("with-red-button")}>
      <:icon>
        <div class="rounded-full bg-red-100 p-3">
          <.icon name="hero-exclamation-triangle" class="h-6 w-6 text-red-600" />
        </div>
      </:icon>
      <:title>With red button</:title>
      <%= lorem_ipsum_sentences(3) %>
      <:confirm class="bg-red-600 hover:bg-red-700">OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>

    <.modal id="with-navigate-button" on_confirm={JS.navigate(~p"/modals-advanced")}>
      <:title>With navigate button</:title>
      Try advanced modals?
      <:confirm>Take me there!</:confirm>
    </.modal>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/modals_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("ok", %{"modal" => modal}, socket) do
    Process.send_after(self(), :reset, 1000)
    {:noreply, assign(socket, :modal, modal)}
  end

  def handle_info(:reset, socket) do
    {:noreply, assign(socket, :modal, nil)}
  end
end
