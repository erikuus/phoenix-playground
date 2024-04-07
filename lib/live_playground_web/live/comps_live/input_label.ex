defmodule LivePlaygroundWeb.CompsLive.InputLabel do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :name, "Erik")}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Label
      <:subtitle>
        Labeling Inputs in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def label">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.label for="name-id">Name</.label>
    <.input id="name-id" name="name" type="text" value={@name} />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/input_label.ex" />
      <.note icon="hero-information-circle">
        The Label component is rarely used on its own; it's primarily utilized within the Input component.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
