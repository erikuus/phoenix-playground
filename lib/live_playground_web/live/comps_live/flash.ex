defmodule LivePlaygroundWeb.CompsLive.Flash do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Flash
      <:subtitle>
        How to use flash component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def flash">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 xl:flex-row xl:space-x-3 xl:space-y-0">
      <.button_link phx-click={show("#text-only-info")}>
        Text only info
      </.button_link>
      <.button_link phx-click={show("#info-with-title")}>
        Info with title
      </.button_link>
      <.button_link phx-click={show("#error-with-title")}>
        Error with title
      </.button_link>
      <.button_link phx-click={show("#error-without-close")}>
        Without close button
      </.button_link>
      <.button_link phx-click={JS.push("set-flash", value: %{msg: placeholder_sentences(3, true)}) |> show("#flash-messages-info")}>
        Flash messages info
      </.button_link>
    </div>

    <.flash id="autoshow-info" kind={:info} title="Autoshow info">
      <%= placeholder_sentences(3, true) %>
    </.flash>

    <.flash id="text-only-info" kind={:info} autoshow={false}>
      <%= placeholder_sentences(3, true) %>
    </.flash>

    <.flash id="info-with-title" kind={:info} autoshow={false} title="Info with title">
      <%= placeholder_sentences(3, true) %>
    </.flash>

    <.flash id="error-with-title" kind={:error} autoshow={false} title="Error with title">
      <%= placeholder_sentences(3, true) %>
    </.flash>

    <.flash id="error-without-close" kind={:error} autoshow={false} close={false} title="Error without close button">
      <%= placeholder_sentences(3, true) %>
    </.flash>

    <.flash id="flash-messages-info" kind={:info} flash={@flash} title="Flash messages info" />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/flash.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("set-flash", %{"msg" => msg}, socket) do
    {:noreply, put_flash(socket, :info, msg)}
  end
end
