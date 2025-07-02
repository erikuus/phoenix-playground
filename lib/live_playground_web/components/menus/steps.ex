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
        title: "Introduction",
        description: "What we're building and why we chose advanced LiveView patterns",
        path: ~p"/steps/introduction",
        order: 1
      },
      %{
        title: "Generate Foundation",
        description: "Start with basic Phoenix LiveView generated code",
        path: ~p"/steps/generated",
        order: 2
      },
      %{
        title: "Implement Pagination",
        description: "Add advanced pagination with real-time updates and concurrency handling",
        path: ~p"/steps/paginated",
        order: 3
      },
      %{
        title: "Extract Pagination Helper",
        description: "Refactor pagination logic into reusable helper module",
        path: ~p"/steps/refactored",
        order: 4
      },
      %{
        title: "Add Sorting Helper",
        description: "Implement column sorting with the same helper pattern",
        path: ~p"/steps/sorted",
        order: 5
      },
      %{
        title: "Add Filtering Helper",
        description: "Complete the trilogy with search and filter functionality",
        path: ~p"/steps/filtered",
        order: 6
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
