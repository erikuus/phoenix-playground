defmodule LivePlaygroundWeb.CompsLive.SlideoverSubtitle do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :slideover, nil)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Slideover with Subtitle
      <:subtitle>
        How to Add Subtitle to Slideover
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def slideover">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show_slideover("with-subtitle")}>
      Show slideover
    </.button_link>
    <.slideover id="with-subtitle" on_confirm={JS.push("ok", value: %{slideover: "With subtitle"}) |> hide_slideover("with-subtitle")}>
      <:title>With subtitle</:title>
      <:subtitle>Subtitle</:subtitle>
      <%= placeholder_sentences(3) %>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.slideover>
    <.alert :if={@slideover} kind={:success} class="mt-6">
      Slideover "<%= @slideover %>" confirmed!
    </.alert>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/slideover_subtitle.ex" />
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
