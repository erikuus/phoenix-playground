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
            label: "Header",
            path: "/header",
            active: is_active?(current_path, ["/header"])
          },
          %{
            label: "Flash",
            path: "/flash",
            active: is_active?(current_path, ["/flash"])
          },
          %{
            label: "Modal",
            path: "/modal",
            active: is_active?(current_path, ["/modal"])
          },
          %{
            label: "Input",
            path: "/input",
            badge: 3,
            active: is_active?(current_path, ["/input", "/label", "/error"])
          },
          %{
            label: "Button",
            path: "/button",
            active: is_active?(current_path, ["/button"])
          },
          %{
            label: "Simple Form",
            path: "/simple-form",
            active: is_active?(current_path, ["/simple-form"])
          },
          %{
            label: "List",
            path: "/list",
            active: is_active?(current_path, ["/list"])
          },
          %{
            label: "Icon",
            path: "/icon",
            active: is_active?(current_path, ["/icon"])
          },
          %{
            label: "Back",
            path: "/back",
            active: is_active?(current_path, ["/back"])
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
          },
          %{
            label: "Button Link",
            path: "/button-link",
            active: is_active?(current_path, ["/button-link"])
          },
          %{
            label: "Alert",
            path: "/alert",
            active: is_active?(current_path, ["/alert"])
          },
          %{
            label: "Note",
            path: "/note",
            active: is_active?(current_path, ["/note"])
          }
        ]
      }
    ]
  end

  defp is_active?(current_path, paths) do
    if current_path in paths, do: true, else: false
  end
end
