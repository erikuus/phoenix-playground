defmodule LivePlaygroundWeb.CompsLive.StepsNavigation do
  use LivePlaygroundWeb, :live_view

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
      Step Navigation
      <:subtitle>
        Navigating Steps in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def steps">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.steps>
      <:step :for={menu <- get_steps(@current_step)} path={menu.path} checked={menu.checked} active={menu.active}>
        <p class="text-sm text-gray-900 font-medium">
          <%= menu.title %>
        </p>
        <p class="text-xs text-gray-600">
          <%= menu.description %>
        </p>
      </:step>
    </.steps>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/steps-navigation.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp get_steps(current_step) do
    [
      %{
        title: "Step 1",
        description: placeholder_sentences(2),
        path: ~p"/steps-navigation?#{[step: 1]}",
        checked: is_checked?(current_step, 1),
        active: is_active?(current_step, 1)
      },
      %{
        title: "Step 2",
        description: placeholder_sentences(3),
        path: ~p"/steps-navigation?#{[step: 2]}",
        checked: is_checked?(current_step, 2),
        active: is_active?(current_step, 2)
      },
      %{
        title: "Step 3",
        description: placeholder_sentences(2),
        path: ~p"/steps-navigation?#{[step: 3]}",
        checked: is_checked?(current_step, 3),
        active: is_active?(current_step, 3)
      },
      %{
        title: "Step 4",
        description: placeholder_sentences(2),
        path: ~p"/steps-navigation?#{[step: 4]}",
        checked: is_checked?(current_step, 4),
        active: is_active?(current_step, 4)
      }
    ]
  end

  defp is_checked?(current_step, step) do
    current_step >= step
  end

  defp is_active?(current_step, step) do
    current_step == step
  end
end
