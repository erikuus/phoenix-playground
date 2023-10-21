defmodule LivePlaygroundWeb.CompsLive.Error do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Error
      <:subtitle>
        How to use error component
      </:subtitle>
      <:actions class="flex-col space-y-2 items-end">
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def error">
          Goto Definition
        </.goto_definition>
        <.link navigate={~p"/input"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Input
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.error>Houston, we have a problem</.error>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/error.ex" />
      <.note icon="hero-information-circle">
        The Error component is rarely used on its own; it's primarily utilized within the Input component.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
