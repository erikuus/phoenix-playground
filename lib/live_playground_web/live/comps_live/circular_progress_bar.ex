defmodule LivePlaygroundWeb.CompsLive.CircularProgressBar do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Circular Progress Bar
      <:subtitle>
        Integrating Circular Progress Bars in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def circular_progress_bar">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="flex items-center space-x-6">
      <.circular_progress_bar progress={70} stroke_width={4} radius={17.0} svg_class="mt-2 w-10 h-10" />
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/circular_progress_bar.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
