defmodule LivePlaygroundWeb.CompsLive.Slideover do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :slideover, nil)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Slideover
      <:subtitle>
        How to use slideover component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def slideover">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 xl:flex-row xl:space-x-3 xl:space-y-0">
      <.button_link phx-click={show_slideover("basic")}>
        Basic
      </.button_link>
      <.button_link phx-click={show_slideover("with-subtitle")}>
        With subtitle
      </.button_link>
      <.button_link phx-click={show_slideover("with-scrollbar")}>
        With scrollbar
      </.button_link>
      <.button_link phx-click={show_slideover("with-red-button")}>
        With red button
      </.button_link>
      <.button_link phx-click={show_slideover("with-navigate-button")}>
        With navigate button
      </.button_link>
      <.button_link patch={~p"/slideover/image"}>
        With live component
      </.button_link>
    </div>

    <.alert :if={@slideover} look="success" class="mt-6">
      Slideover "<%= @slideover %>" confirmed!
    </.alert>

    <.slideover id="basic" on_confirm={JS.push("ok", value: %{slideover: "Basic"}) |> hide_slideover("basic")}>
      <:title>Basic</:title>
      <%= placeholder_sentences(3) %>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.slideover>

    <.slideover id="with-subtitle" on_confirm={JS.push("ok", value: %{slideover: "With subtitle"}) |> hide_slideover("with-subtitle")}>
      <:title>With subtitle</:title>
      <:subtitle>Subtitle</:subtitle>
      <%= placeholder_sentences(3) %>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.slideover>

    <.slideover
      id="with-scrollbar"
      on_confirm={JS.push("ok", value: %{slideover: "With scrollbar"}) |> hide_slideover("with-scrollbar")}
    >
      <:title>With subtitle</:title>
      <div class="space-y-6">
        <%= placeholder_paragraphs(20) %>
      </div>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.slideover>

    <.slideover
      id="with-red-button"
      on_confirm={JS.push("ok", value: %{slideover: "With red button"}) |> hide_slideover("with-red-button")}
    >
      <:title>With red button</:title>
      <%= placeholder_sentences(3) %>
      <:confirm class="bg-red-600 hover:bg-red-700">OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.slideover>

    <.slideover id="with-navigate-button" on_confirm={JS.navigate(~p"/modal")}>
      <:title>With navigate button</:title>
      Navigate to modal
      <:confirm>Go</:confirm>
    </.slideover>

    <.slideover :if={@live_action == :image} id="image-slideover" show on_cancel={JS.navigate(~p"/slideover")} width_class="max-w-5xl">
      <.live_component
        module={LivePlaygroundWeb.CompsLive.ImageComponent}
        id={:image}
        title="Image Component"
        images={["DSC02232.jpg", "DSC02234.jpg", "DSC02235.jpg"]}
        return_text="Close"
        return_to={~p"/slideover"}
      />
    </.slideover>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/comps_live/slideover.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("ok", %{"slideover" => slideover}, socket) do
    Process.send_after(self(), :reset, 2000)
    {:noreply, assign(socket, :slideover, slideover)}
  end

  def handle_info(:reset, socket) do
    {:noreply, assign(socket, :slideover, nil)}
  end
end
