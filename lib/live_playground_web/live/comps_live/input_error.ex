defmodule LivePlaygroundWeb.CompsLive.InputError do
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
        How to Display Error
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def error">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.error>Houston, we have a problem</.error>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/input_error.ex" />
      <.note icon="hero-information-circle">
        The Error component is rarely used on its own; it's primarily utilized within the Input component.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
