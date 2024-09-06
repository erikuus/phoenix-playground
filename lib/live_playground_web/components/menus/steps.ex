defmodule LivePlaygroundWeb.Menus.Steps do
  use Phoenix.Component

  import LivePlaygroundWeb.MoreComponents

  attr :current_path, :string

  def menu(assigns) do
    ~H"""
    <.steps>
      <:step :for={step <- get_steps(@current_path)} path={step.path} active={step.active} checked={step.checked}>
        <p class="text-sm text-gray-900 font-medium">
          <%= step.title %>
        </p>
        <p class="text-xs text-gray-500">
          <%= step.description %>
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
        title: "Generated",
        description:
          "Run mix phx.gen.live command to generate LiveViews, components, and context for a resource.",
        path: "/steps/generated",
        order: 1
      },
      %{
        title: "Paginated",
        description: "Add pagination to generated LiveView",
        path: "/steps/paginated",
        order: 2
      },
      %{
        title: "Step 3",
        description: "Coming soon",
        path: "/steps/coming-soon",
        order: 3
      },
      %{
        title: "Step 4",
        description: "Coming soon",
        path: "/steps/coming-soon",
        order: 4
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
    |> Enum.find(%{order: 0}, fn step -> step.path == path end)
    |> Map.get(:order)
  end
end
