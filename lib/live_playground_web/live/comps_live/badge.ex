defmodule LivePlaygroundWeb.CompsLive.Badge do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Badge
      <:subtitle>
        Displaying Badges in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def badge">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex items-start flex-col space-x-0 space-y-3 md:flex-row md:space-x-3 md:space-y-0">
      <.badge>Default</.badge>
      <.badge kind={:red}>Red</.badge>
      <.badge kind={:yellow}>Yellow</.badge>
      <.badge kind={:green}>Green</.badge>
      <.badge kind={:blue}>Blue</.badge>
      <.badge kind={:indigo}>Indigo</.badge>
      <.badge kind={:purple}>Purple</.badge>
      <.badge kind={:pink}>Pink</.badge>
      <.badge class="text-sm font-bold px-4 py-2">Custom Style</.badge>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/badge.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
