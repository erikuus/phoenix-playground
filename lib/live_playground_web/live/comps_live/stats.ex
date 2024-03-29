defmodule LivePlaygroundWeb.CopmsLive.Stats do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Stats
      <:subtitle>
        How to Display Statistical Data Cards
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def stats">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.stats>
      <:card title="Total Users">
        8,472
      </:card>
      <:card title="Monthly Sales">
        $12,345
      </:card>
      <:card title="Page Views">
        54,321
      </:card>
      <:card title="Active Projects">
        23
      </:card>
      <:card title="Downloads">
        2,789
      </:card>
      <:card title="Feedback Submitted">
        158
      </:card>
      <:card title="Completed Tasks">
        1,867
      </:card>
      <:card title="Online Visitors">
        324
      </:card>
    </.stats>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/stats.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
