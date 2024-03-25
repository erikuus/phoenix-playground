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
    <.vertical_navigation class="px-3" id={@id} items={get_items(@current_path)} />
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
            icon: "hero-bars-4",
            label: "List",
            path: ~p"/list",
            active: is_active?(current_path, ["/list"])
          },
          %{
            expandable: %{
              id: "flash",
              icon: "hero-rectangle-stack",
              label: "Flash",
              open:
                is_active?(current_path, [
                  "/flash-auto-show",
                  "/flash-text-only",
                  "/flash-info-title",
                  "/flash-error-title",
                  "/flash-error-wo-close",
                  "/flash-put-flash"
                ])
            },
            expandable_items: [
              %{
                label: "Flash Auto Show",
                path: ~p"/flash-auto-show",
                active: is_active?(current_path, ["/flash-auto-show"])
              },
              %{
                label: "Flash with Text Only",
                path: ~p"/flash-text-only",
                active: is_active?(current_path, ["/flash-text-only"])
              },
              %{
                label: "Flash Info with Title",
                path: ~p"/flash-info-title",
                active: is_active?(current_path, ["/flash-info-title"])
              },
              %{
                label: "Flash Error with Title",
                path: ~p"/flash-error-title",
                active: is_active?(current_path, ["/flash-error-title"])
              },
              %{
                label: "Flash without Close Button",
                path: ~p"/flash-error-wo-close",
                active: is_active?(current_path, ["/flash-error-wo-close"])
              },
              %{
                label: "Flash Using Put Flash",
                path: ~p"/flash-put-flash",
                active: is_active?(current_path, ["/flash-put-flash"])
              }
            ]
          },
          %{
            expandable: %{
              id: "modal",
              icon: "hero-window",
              label: "Modal",
              open:
                is_active?(current_path, [
                  "/modal-basic",
                  "/modal-subtitle",
                  "/modal-icon",
                  "/modal-red",
                  "/modal-navigate",
                  "/modal",
                  "/modal/image"
                ])
            },
            expandable_items: [
              %{
                label: "Modal Basics",
                path: ~p"/modal-basic",
                active: is_active?(current_path, ["/modal-basic"])
              },
              %{
                label: "Modal with Subtitle",
                path: ~p"/modal-subtitle",
                active: is_active?(current_path, ["/modal-subtitle"])
              },
              %{
                label: "Modal with Icon",
                path: ~p"/modal-icon",
                active: is_active?(current_path, ["/modal-icon"])
              },
              %{
                label: "Modal in Red",
                path: ~p"/modal-red",
                active: is_active?(current_path, ["/modal-red"])
              },
              %{
                label: "Modal with Navigate",
                path: ~p"/modal-navigate",
                active: is_active?(current_path, ["/modal-navigate"])
              },
              %{
                label: "Modal with Component",
                path: ~p"/modal",
                active: is_active?(current_path, ["/modal", "/modal/image"])
              }
            ]
          },
          %{
            expandable: %{
              id: "table",
              icon: "hero-table-cells",
              label: "Table",
              open:
                is_active?(current_path, [
                  "/table",
                  "/table-action",
                  "/table-row-click",
                  "/table-stream"
                ])
            },
            expandable_items: [
              %{
                label: "Table Basics",
                path: ~p"/table",
                active: is_active?(current_path, ["/table"])
              },
              %{
                label: "Table with Actions",
                path: ~p"/table-action",
                active: is_active?(current_path, ["/table-action"])
              },
              %{
                label: "Table with Row Click",
                path: ~p"/table-row-click",
                active: is_active?(current_path, ["/table-row-click"])
              },
              %{
                label: "Table with Stream",
                path: ~p"/table-stream",
                active: is_active?(current_path, ["/table-stream"])
              }
            ]
          },
          %{
            expandable: %{
              id: "input",
              icon: "hero-pencil-square",
              label: "Input",
              open:
                is_active?(current_path, [
                  "/input-textbox",
                  "/input-textarea",
                  "/input-select",
                  "/input-checkbox",
                  "/input-radio",
                  "/input-label",
                  "/input-error"
                ])
            },
            expandable_items: [
              %{
                label: "Textbox",
                path: ~p"/input-textbox",
                active: is_active?(current_path, ["/input-textbox"])
              },
              %{
                label: "Textarea",
                path: ~p"/input-textarea",
                active: is_active?(current_path, ["/input-textarea"])
              },
              %{
                label: "Select",
                path: ~p"/input-select",
                active: is_active?(current_path, ["/input-select"])
              },
              %{
                label: "Checkbox",
                path: ~p"/input-checkbox",
                active: is_active?(current_path, ["/input-checkbox"])
              },
              %{
                label: "Radio",
                path: ~p"/input-radio",
                active: is_active?(current_path, ["/input-radio"])
              },
              %{
                label: "Label",
                path: ~p"/input-label",
                active: is_active?(current_path, ["/input-label"])
              },
              %{
                label: "Error",
                path: ~p"/input-error",
                active: is_active?(current_path, ["/input-error"])
              }
            ]
          },
          %{
            icon: "hero-document-text",
            label: "Form",
            path: ~p"/simple-form",
            active: is_active?(current_path, ["/simple-form"])
          },
          %{
            icon: "hero-cursor-arrow-ripple",
            label: "Button",
            path: ~p"/button",
            active: is_active?(current_path, ["/button"])
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
            icon: "hero-list-bullet",
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
                  "/vertical-navigation-expandable",
                  "/vertical-navigation-showcase"
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
              },
              %{
                label: "Full Functionality",
                path: ~p"/vertical-navigation-showcase",
                active: is_active?(current_path, ["/vertical-navigation-showcase"])
              }
            ]
          },
          %{
            expandable: %{
              id: "slideover",
              icon: "hero-arrow-left-on-rectangle",
              label: "Slideover",
              open:
                is_active?(current_path, [
                  "/slideover-basic",
                  "/slideover-subtitle",
                  "/slideover-scrollbar",
                  "/slideover-red",
                  "/slideover-navigate",
                  "/slideover",
                  "/slideover/image"
                ])
            },
            expandable_items: [
              %{
                label: "Slideover Basics",
                path: ~p"/slideover-basic",
                active: is_active?(current_path, ["/slideover-basic"])
              },
              %{
                label: "Slideover with Subtitle",
                path: ~p"/slideover-subtitle",
                active: is_active?(current_path, ["/slideover-subtitle"])
              },
              %{
                label: "Slideover with Scrollbar",
                path: ~p"/slideover-scrollbar",
                active: is_active?(current_path, ["/slideover-scrollbar"])
              },
              %{
                label: "Slideover in Red",
                path: ~p"/slideover-red",
                active: is_active?(current_path, ["/slideover-red"])
              },
              %{
                label: "Slideover with Navigate",
                path: ~p"/slideover-navigate",
                active: is_active?(current_path, ["/slideover-navigate"])
              },
              %{
                label: "Slideover with Component",
                path: ~p"/slideover",
                active: is_active?(current_path, ["/slideover", "/slideover/image"])
              }
            ]
          },
          %{
            expandable: %{
              id: "steps",
              icon: "hero-check-circle",
              label: "Steps",
              open:
                is_active?(current_path, [
                  "/steps-navigation",
                  "/steps-progress"
                ])
            },
            expandable_items: [
              %{
                label: "Step Navigation",
                path: ~p"/steps-navigation",
                active: is_active?(current_path, ["/steps-navigation"])
              },
              %{
                label: "Step Progress",
                path: ~p"/steps-progress",
                active: is_active?(current_path, ["/steps-progress"])
              }
            ]
          },
          %{
            icon: "hero-cursor-arrow-rays",
            label: "Button Link",
            path: ~p"/button-link",
            active: is_active?(current_path, ["/button-link"])
          },
          %{
            icon: "hero-exclamation-triangle",
            label: "Alert",
            path: ~p"/alert",
            active: is_active?(current_path, ["/alert"])
          },          
          %{
            icon: "hero-light-bulb",
            label: "Note",
            path: ~p"/note",
            active: is_active?(current_path, ["/note"])
          },
          %{
            icon: "hero-bars-4",
            label: "Simple List",
            path: ~p"/simple-list",
            active: is_active?(current_path, ["/simple-list"])
          },
          %{
            icon: "hero-square-3-stack-3d",
            label: "Tabs",
            path: ~p"/tabs",
            active: is_active?(current_path, ["/tabs"])
          },
          %{
            icon: "hero-squares-2x2",
            label: "Stats",
            path: ~p"/stats",
            active: is_active?(current_path, ["/stats"])
          },
          %{
            icon: "hero-arrow-path",
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
