defmodule LivePlaygroundWeb.CompsLive.Note do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Note
      <:subtitle>
        Presenting Notes in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def note">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="space-y-2">
      <.note icon="hero-light-bulb"><%= placeholder_sentences(1, true) %></.note>
      <.note icon="hero-bell" class="text-sm text-yellow-900 bg-yellow-50"><%= placeholder_sentences(12, true) %></.note>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/note.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
