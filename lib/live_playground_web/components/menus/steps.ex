defmodule LivePlaygroundWeb.Menus.Steps do
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: LivePlaygroundWeb.Endpoint,
    router: LivePlaygroundWeb.Router,
    statics: LivePlaygroundWeb.static_paths()

  import LivePlaygroundWeb.MoreComponents

  attr :current_path, :string

  def menu(assigns) do
    ~H"""
    <.steps>
      <:step :for={step <- get_steps(@current_path)} path={step.path} active={step.active} checked={step.checked}>
        <p class="text-sm text-zinc-900 font-medium">
          {step.title}
        </p>
        <p class="text-xs text-zinc-600">
          {step.description}
        </p>
      </:step>
    </.steps>
    """
  end

  defp get_steps(current_path) do
    get_steps()
    |> Enum.map(&Map.put(&1, :active, is_active?(current_path, &1)))
    |> Enum.map(&Map.put(&1, :checked, is_checked?(current_path, &1)))
  end

  defp get_steps() do
    [
      %{
        title: "Generate",
        description: "Create the foundation with mix phx.gen.live",
        path: ~p"/steps/generated",
        order: 1
      },
      %{
        title: "Add Pagination",
        description: "Enhance with advanced pagination",
        path: ~p"/steps/paginated",
        order: 2
      },
      %{
        title: "Extract Pagination Logic",
        description: "Refactor pagination into a helper module",
        path: ~p"/steps/refactored",
        order: 3
      },
      %{
        title: "Add Sorting",
        description: "Implement dynamic column ordering",
        path: ~p"/steps/sorted",
        order: 4
      },
      %{
        title: "Add Filtering",
        description: "Implement filtering to narrow results",
        path: ~p"/steps/filtered",
        order: 5
      }
    ]
  end

  defp is_active?(current_path, step) do
    String.starts_with?(current_path, step.path)
  end

  defp is_checked?(current_path, step) do
    get_order_by_path(current_path) >= step.order
  end

  defp get_order_by_path(path) do
    get_steps()
    |> Enum.find(%{order: 0}, fn step -> is_active?(path, step) end)
    |> Map.get(:order)
  end
end
