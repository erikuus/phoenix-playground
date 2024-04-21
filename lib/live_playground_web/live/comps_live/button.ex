defmodule LivePlaygroundWeb.CompsLive.Button do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :button, nil)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Button
      <:subtitle>
        Styling Buttons in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def button">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex flex-col space-x-0 space-y-3 sm:flex-row sm:space-x-3 sm:space-y-0">
      <.button phx-click="ok" phx-value-button="Default">Default</.button>
      <.button phx-click="ok" phx-value-button="Secondary" kind={:secondary}>Secondary</.button>
      <.button phx-click="ok" phx-value-button="Dangerous" kind={:dangerous}>Dangerous</.button>
    </div>
    <.alert :if={@button} kind={:success} class="mt-6">
      Button "<%= @button %>" clicked!
    </.alert>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/button.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("ok", %{"button" => button}, socket) do
    Process.send_after(self(), :reset, 2000)
    {:noreply, assign(socket, :button, button)}
  end

  def handle_info(:reset, socket) do
    {:noreply, assign(socket, :button, nil)}
  end
end
