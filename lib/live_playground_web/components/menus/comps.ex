defmodule LivePlaygroundWeb.Menus.Comps do
  use Phoenix.Component

  import LivePlaygroundWeb.MoreComponents

  attr :current_path, :string
  attr :text_class, :string, default: "text-sm"

  def menu(assigns) do
    ~H"""
    <.vertical_navigation_grouped items={get_items(@current_path)} />
    """
  end

  defp get_items(current_path) do
    [
      %{
        group: "Core components",
        subitems: [
          %{
            label: "Modal",
            path: "/modal",
            active: is_active?(current_path, ["/modal"])
          }
        ]
      },
      %{
        group: "More components",
        subitems: [
          %{
            label: "Slideover",
            path: "/slideover",
            active: is_active?(current_path, ["/slideover"])
          }
        ]
      }
    ]
  end

  defp is_active?(current_path, paths) do
    if current_path in paths, do: true, else: false
  end
end
