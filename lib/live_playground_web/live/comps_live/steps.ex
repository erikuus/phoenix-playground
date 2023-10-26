defmodule LivePlaygroundWeb.CompsLive.Steps do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"step" => step}, _url, socket) do
    {:noreply, assign(socket, :current_step, String.to_integer(step))}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :current_step, 1)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Steps
      <:subtitle>
        How to use Steps List component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def steps">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="grid gap-6 grid-cols-1 sm:grid-cols-2">
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          Menu
        </h2>
        <.steps>
          <:step :for={menu <- get_steps(@current_step)} path={menu.path} checked={menu.checked} active={menu.active}>
            <p class="text-sm text-gray-900 font-medium">
              <%= menu.title %>
            </p>
            <p class="text-xs text-gray-500">
              <%= menu.description %>
            </p>
          </:step>
        </.steps>
      </div>
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          Progress
        </h2>
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
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/steps.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp get_steps(current_step) do
    [
      %{
        title: "Step 1",
        description: placeholder_sentences(2),
        path: ~p"/steps?#{[step: 1]}",
        checked: is_checked?(current_step, 1),
        active: is_active?(current_step, 1)
      },
      %{
        title: "Step 2",
        description: placeholder_sentences(3),
        path: ~p"/steps?#{[step: 2]}",
        checked: is_checked?(current_step, 2),
        active: is_active?(current_step, 2)
      },
      %{
        title: "Step 3",
        description: placeholder_sentences(2),
        path: ~p"/steps?#{[step: 3]}",
        checked: is_checked?(current_step, 3),
        active: is_active?(current_step, 3)
      },
      %{
        title: "Step 4",
        description: placeholder_sentences(2),
        path: ~p"/steps?#{[step: 4]}",
        checked: is_checked?(current_step, 4),
        active: is_active?(current_step, 4)
      }
    ]
  end

  defp is_checked?(current_step, step) do
    if current_step >= step, do: true, else: false
  end

  defp is_active?(current_step, step) do
    if current_step == step, do: true, else: false
  end
end
