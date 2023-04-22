defmodule LivePlaygroundWeb.ModalsLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :modal, nil)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Modals
      <:subtitle>
        How to use core modal component
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 xl:flex-row xl:space-x-3 xl:space-y-0">
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
      <.button_link patch={~p"/modals/image"}>
        With live component
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
    <.modal id="with-navigate-button" on_confirm={JS.navigate(~p"/click-buttons")}>
      <:title>With navigate button</:title>
      Recipes
      <:confirm>Get started</:confirm>
    </.modal>
    <.modal :if={@live_action == :image} id="image-modal" show on_cancel={JS.navigate(~p"/modals")} content_class="max-w-5xl">
      <.live_component
        module={LivePlaygroundWeb.Components.ImageComponent}
        id={:image}
        title="Image Component"
        images={["DSC02232.jpg", "DSC02234.jpg", "DSC02235.jpg"]}
        return_text="Close"
        return_to={~p"/modals"}
      />
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
