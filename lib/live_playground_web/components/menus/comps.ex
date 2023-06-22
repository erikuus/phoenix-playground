defmodule LivePlaygroundWeb.Menus.Comps do
  use Phoenix.Component

  import LivePlaygroundWeb.MoreComponents

  attr :current_path, :string
  attr :text_class, :string, default: "text-sm"

  def menu(assigns) do
    ~H"""
    <.vertical_navigation items={get_items(@current_path)} text_class={@text_class} />
    """
  end

  defp get_items(current_path) do
    get_items()
    |> Enum.map(&Map.put(&1, :active, is_active?(current_path, &1)))
    |> Enum.map(&Map.put(&1, :icon, nil))
    |> Enum.map(&Map.put(&1, :badge, nil))
  end

  defp is_active?(current_path, item) do
    if current_path in item.paths, do: true, else: false
  end

  defp get_items() do
    [
      %{
        label: "Core components",
        path: nil,
        paths: []
      },
      %{
        label: "Modal",
        path: "/modal",
        paths: ["/modal"]
      },
      %{
        label: "More components",
        path: nil,
        paths: []
      },
      %{
        label: "Slideover",
        path: "/slideover",
        paths: ["/slideover"]
      }
    ]
  end
end
