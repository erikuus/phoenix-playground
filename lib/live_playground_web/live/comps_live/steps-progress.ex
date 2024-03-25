defmodule LivePlaygroundWeb.CompsLive.StepsProgress do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Step Progress
      <:subtitle>
        How to Implement the Steps Component for Progress
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def steps">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.steps>
      <:step active={true}>
        Shopping Cart Review
      </:step>
      <:step active={true}>
        Shipping Address
      </:step>
      <:step active={true}>
        Shipping Method
      </:step>
      <:step active={true}>
        Payment Information
      </:step>
      <:step active={false}>
        Billing Address
      </:step>
      <:step active={false}>
        Review Order
      </:step>
      <:step active={false}>
        Place Order
      </:step>
    </.steps>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/steps-progress.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
