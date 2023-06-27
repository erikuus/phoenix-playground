defmodule LivePlaygroundWeb.Menus.Steps do
  use Phoenix.Component

  import LivePlaygroundWeb.MoreComponents

  attr :current_path, :string

  def menu(assigns) do
    ~H"""
    <.steps>
      <:step :for={step <- get_steps(@current_path)} path={step.path} active={step.active}>
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
    get_steps() |> Enum.map(&Map.put(&1, :active, is_active?(current_path, &1)))
  end

  defp get_steps() do
    [
      %{
        title: "Generate",
        description:
          "Run mix phx.gen.live command to generate LiveViews, components, and context for a resource.",
        path: "/languages4"
      },
      %{
        title: "Step 2",
        description: LivePlaygroundWeb.DemoHelpers.lorem_ipsum_sentences(2, true),
        path: "/languages"
      },
      %{
        title: "Step 3",
        description: LivePlaygroundWeb.DemoHelpers.lorem_ipsum_sentences(2, true),
        path: "/languages3"
      },
      %{
        title: "Step 4",
        description: LivePlaygroundWeb.DemoHelpers.lorem_ipsum_sentences(2, true),
        path: "/languages2"
      }
    ]
  end

  defp is_active?(current_path, step) do
    if String.starts_with?(current_path, step.path), do: true, else: false
  end
end
