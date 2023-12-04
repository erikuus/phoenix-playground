defmodule LivePlaygroundWeb.Menus.Comps do
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: LivePlaygroundWeb.Endpoint,
    router: LivePlaygroundWeb.Router,
    statics: LivePlaygroundWeb.static_paths()

  import LivePlaygroundWeb.MoreComponents

  attr :id, :string, required: true
  attr :current_path, :string

  def menu(assigns) do
    ~H"""
    <.vertical_navigation id={@id} items={get_items(@current_path)} />
    """
  end

  defp get_items(current_path) do
    [
      %{
        section: %{
          label: "CORE COMPONENTS"
        },
        section_items: [
          %{
            icon: "hero-queue-list",
            label: "Header",
            path: ~p"/header",
            active: is_active?(current_path, ["/header"])
          },
          %{
            icon: "hero-rectangle-stack",
            label: "Flash",
            path: ~p"/flash",
            active: is_active?(current_path, ["/flash"])
          },
          %{
            icon: "hero-window",
            label: "Modal",
            path: ~p"/modal",
            active: is_active?(current_path, ["/modal"])
          },
          %{
            icon: "hero-pencil-square",
            label: "Input",
            path: ~p"/input",
            badge: 3,
            active: is_active?(current_path, ["/input", "/label", "/error"])
          },
          %{
            icon: "hero-cursor-arrow-ripple",
            label: "Button",
            path: ~p"/button",
            active: is_active?(current_path, ["/button"])
          },
          %{
            icon: "hero-squares-2x2",
            label: "Simple Form",
            path: ~p"/simple-form",
            active: is_active?(current_path, ["/simple-form"])
          },
          %{
            icon: "hero-table-cells",
            label: "Table",
            path: ~p"/table",
            active: is_active?(current_path, ["/table"])
          },
          %{
            icon: "hero-bars-4",
            label: "List",
            path: ~p"/list",
            active: is_active?(current_path, ["/list"])
          },
          %{
            icon: "hero-cake",
            label: "Icon",
            path: ~p"/icon",
            active: is_active?(current_path, ["/icon"])
          },
          %{
            icon: "hero-arrow-uturn-left",
            label: "Back",
            path: ~p"/back",
            active: is_active?(current_path, ["/back"])
          }
        ]
      },
      %{
        section: %{
          label: "MORE COMPONENTS"
        },
        section_items: [
          %{
            icon: "hero-view-columns",
            label: "Multi-Column Layout",
            path: ~p"/multi-column-layout",
            active: is_active?(current_path, ["/multi-column-layout"])
          },
          %{
            icon: "hero-ellipsis-vertical",
            label: "Narrow Sidebar",
            path: ~p"/narrow-sidebar",
            active: is_active?(current_path, ["/narrow-sidebar"])
          },
          %{
            expandable: %{
              id: "vertical-navigation",
              icon: "hero-bars-3",
              label: "Vertical Navigation",
              open:
                is_active?(current_path, [
                  "/vertical-navigation",
                  "/vertical-navigation-sections",
                  "/vertical-navigation-expandable"
                ])
            },
            expandable_items: [
              %{
                label: "Single Level Navigation",
                path: ~p"/vertical-navigation",
                active: is_active?(current_path, ["/vertical-navigation"])
              },
              %{
                label: "Sectional Navigation",
                path: ~p"/vertical-navigation-sections",
                active: is_active?(current_path, ["/vertical-navigation-sections"])
              },
              %{
                label: "Expandable Navigation",
                path: ~p"/vertical-navigation-expandable",
                active: is_active?(current_path, ["/vertical-navigation-expandable"])
              }
            ]
          },
          %{
            icon: "hero-arrow-right-on-rectangle",
            label: "Slideover",
            path: ~p"/slideover",
            active: is_active?(current_path, ["/slideover"])
          },
          %{
            label: "Button Link",
            path: ~p"/button-link",
            active: is_active?(current_path, ["/button-link"])
          },
          %{
            label: "Alert",
            path: ~p"/alert",
            active: is_active?(current_path, ["/alert"])
          },
          %{
            label: "Note",
            path: ~p"/note",
            active: is_active?(current_path, ["/note"])
          },
          %{
            label: "Simple List",
            path: ~p"/simple_list",
            active: is_active?(current_path, ["/simple_list"])
          },
          %{
            label: "Steps",
            path: ~p"/steps",
            active: is_active?(current_path, ["/steps"])
          },
          %{
            label: "Tabs",
            path: ~p"/tabs",
            active: is_active?(current_path, ["/tabs"])
          },
          %{
            label: "Stats",
            path: ~p"/stats",
            active: is_active?(current_path, ["/stats"])
          },
          %{
            label: "Loading",
            path: ~p"/loading",
            active: is_active?(current_path, ["/loading"])
          }
        ]
      }
    ]
  end

  defp is_active?(current_path, paths) do
    if current_path in paths, do: true, else: false
  end
end
