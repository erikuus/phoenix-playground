defmodule LivePlaygroundWeb.Menus.Comps do
  alias LivePlaygroundWeb.CompsLive.VerticalNavigation
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
          },
          %{
            label: "Multi-Column Layout",
            path: "/multi-column-layout",
            active: is_active?(current_path, ["/multi-column-layout"])
          },
          %{
            label: "Narrow Sidebar",
            path: "/narrow-sidebar",
            active: is_active?(current_path, ["/narrow-sidebar"])
          },
          %{
            label: "Vertical Navigation",
            path: "/vertical-navigation",
            active: is_active?(current_path, ["/vertical-navigation"])
          },
          %{
            label: "Grouped Vertical Navigation",
            path: "/vertical-navigation-grouped",
            active: is_active?(current_path, ["/vertical-navigation-grouped"])
          }
        ]
      }
    ]
  end

  defp is_active?(current_path, paths) do
    if current_path in paths, do: true, else: false
  end
end
