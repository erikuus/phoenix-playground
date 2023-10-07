defmodule LivePlaygroundWeb.Menus.Comps do
  use Phoenix.Component

  import LivePlaygroundWeb.MoreComponents

  attr :current_path, :string
  attr :text_class, :string, default: "text-sm"

  def menu(assigns) do
    ~H"""
    <.vertical_navigation items={get_items(@current_path)} />
    """
  end

  defp get_items(current_path) do
    [
      %{
        section: "Core components",
        subitems: [
          %{
            label: "Modal",
            path: "/modal",
            active: is_active?(current_path, ["/modal"])
          },
          %{
            label: "Flash",
            path: "/flash",
            active: is_active?(current_path, ["/flash"])
          }
        ]
      },
      %{
        section: "More components",
        subitems: [
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
            badge: 2,
            active:
              is_active?(current_path, [
                "/vertical-navigation",
                "/vertical-navigation-sections"
              ])
          },
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
