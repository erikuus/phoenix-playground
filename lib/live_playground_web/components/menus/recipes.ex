defmodule LivePlaygroundWeb.Menus.Recipes do
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
        icon: "hero-cursor-arrow-ripple",
        label: "Click Buttons",
        path: ~p"/click-buttons",
        active: is_active?(current_path, ["/click-buttons"])
      },
      %{
        icon: "hero-link",
        label: "Handle Params",
        path: ~p"/handle-params",
        active: is_active?(current_path, ["/handle-params"])
      },
      %{
        icon: "hero-arrow-path-rounded-square",
        label: "Change Form",
        path: ~p"/change-form",
        active: is_active?(current_path, ["/change-form"])
      },
      %{
        icon: "hero-cube",
        label: "Key Events",
        path: ~p"/key-events",
        active: is_active?(current_path, ["/key-events"])
      },
      %{
        icon: "hero-command-line",
        label: "JS Commands",
        path: ~p"/js-commands",
        active: is_active?(current_path, ["/js-commands"])
      },
      %{
        expandable: %{
          id: "send-messages",
          icon: "hero-paper-airplane",
          label: "Send Messages",
          open:
            is_active?(current_path, [
              "/send-interval",
              "/send-after"
            ])
        },
        expandable_items: [
          %{
            label: "Send Repeatedly",
            path: ~p"/send-interval",
            active: is_active?(current_path, ["/send-interval"])
          },
          %{
            label: "Send After",
            path: ~p"/send-after",
            active: is_active?(current_path, ["/send-after"])
          }
        ]
      },
      %{
        expandable: %{
          id: "autocomplete",
          icon: "hero-bars-arrow-down",
          label: "Autocomplete",
          open:
            is_active?(current_path, [
              "/autocomplete",
              "/autocomplete-custom"
            ])
        },
        expandable_items: [
          %{
            label: "Native Autocomplete",
            path: ~p"/autocomplete",
            active: is_active?(current_path, ["/autocomplete"])
          },
          %{
            label: "Custom Autocomplete",
            path: ~p"/autocomplete-custom",
            active: is_active?(current_path, ["/autocomplete-custom"])
          }
        ]
      },
      %{
        expandable: %{
          id: "search",
          icon: "hero-magnifying-glass",
          label: "Search",
          open:
            is_active?(current_path, [
              "/search",
              "/search-param"
            ])
        },
        expandable_items: [
          %{
            label: "Handle-event Search",
            path: ~p"/search",
            active: is_active?(current_path, ["/search"])
          },
          %{
            label: "Handle-params Search",
            path: ~p"/search-param",
            active: is_active?(current_path, ["/search-param"])
          }
        ]
      },
      %{
        expandable: %{
          id: "filtering",
          icon: "hero-funnel",
          label: "Filtering",
          open:
            is_active?(current_path, [
              "/filter",
              "/filter-params"
            ])
        },
        expandable_items: [
          %{
            label: "Handle-event Filtering",
            path: ~p"/filter",
            active: is_active?(current_path, ["/filter"])
          },
          %{
            label: "Handle-params Filtering",
            path: ~p"/filter-params",
            active: is_active?(current_path, ["/filter-params"])
          }
        ]
      },
      %{
        expandable: %{
          id: "sorting",
          icon: "hero-arrows-up-down",
          label: "Sorting",
          open:
            is_active?(current_path, [
              "/sort",
              "/sort-params"
            ])
        },
        expandable_items: [
          %{
            label: "Handle-event Sorting",
            path: ~p"/sort",
            active: is_active?(current_path, ["/sort"])
          },
          %{
            label: "Handle-params Sorting",
            path: ~p"/sort-params",
            active: is_active?(current_path, ["/sort-params"])
          }
        ]
      },
      %{
        expandable: %{
          id: "pagination",
          icon: "hero-arrows-right-left",
          label: "Pagination",
          open:
            is_active?(current_path, [
              "/paginate",
              "/paginate-params"
            ])
        },
        expandable_items: [
          %{
            label: "Handle-event Pagination",
            path: ~p"/paginate",
            active: is_active?(current_path, ["/paginate"])
          },
          %{
            label: "Handle-params Pagination",
            path: ~p"/paginate-params",
            active: is_active?(current_path, ["/paginate-params"])
          }
        ]
      },
      %{
        expandable: %{
          id: "form",
          icon: "hero-pencil-square",
          label: "Form",
          open:
            is_active?(current_path, [
              "/form-insert",
              "/form-insert-validate"
            ])
        },
        expandable_items: [
          %{
            label: "Validate on Submit",
            path: ~p"/form-insert",
            active: is_active?(current_path, ["/form-insert"])
          },
          %{
            label: "Validate on Change",
            path: ~p"/form-insert-validate",
            active: is_active?(current_path, ["/form-insert-validate"])
          }
        ]
      },
      %{
        expandable: %{
          id: "stream",
          icon: "hero-rss",
          label: "Stream",
          open:
            is_active?(current_path, [
              "/stream-insert",
              "/stream-update",
              "/stream-update/edit",
              "/stream-reset",
              "/stream-reset/edit"
            ])
        },
        expandable_items: [
          %{
            label: "Stream Insert",
            path: ~p"/stream-insert",
            active: is_active?(current_path, ["/stream-insert"])
          },
          %{
            label: "Stream Update",
            path: ~p"/stream-update",
            active: is_active?(current_path, ["/stream-update"])
          },
          %{
            label: "Stream Reset",
            path: ~p"/stream-reset",
            active: is_active?(current_path, ["/stream-reset"])
          }
        ]
      },
      %{
        expandable: %{
          id: "broadcast",
          icon: "hero-signal",
          label: "Broadcast",
          open:
            is_active?(current_path, [
              "/broadcast",
              "/broadcast-stream",
              "/broadcast-stream/edit",
              "/broadcast-stream-reset",
              "/broadcast-stream-reset/edit"
            ])
        },
        expandable_items: [
          %{
            label: "Real-Time Updates",
            path: ~p"/broadcast",
            active: is_active?(current_path, ["/broadcast"])
          },
          %{
            label: "Real-Time Updates with Stream",
            path: ~p"/broadcast-stream",
            active: is_active?(current_path, ["/broadcast-stream"])
          },
          %{
            label: "Real-Time Updates with Stream and Navigation",
            path: ~p"/broadcast-stream-reset",
            active: is_active?(current_path, ["/broadcast-stream-reset"])
          }
        ]
      },
      %{
        icon: "hero-table-cells",
        label: "Tabular Insert",
        path: ~p"/tabular-insert",
        active: is_active?(current_path, ["/tabular-insert"])
      },
      %{
        expandable: %{
          id: "js-hooks",
          icon: "hero-map",
          label: "JS Hooks",
          open:
            is_active?(current_path, [
              "/js-hook-map-dataset",
              "/js-hook-map-push-event",
              "/js-hook-map-handle-event"
            ])
        },
        expandable_items: [
          %{
            label: "Dataset",
            path: ~p"/js-hook-map-dataset",
            active: is_active?(current_path, ["/js-hook-map-dataset"])
          },
          %{
            label: "Push Events",
            path: ~p"/js-hook-map-push-event",
            active: is_active?(current_path, ["/js-hook-map-push-event"])
          },
          %{
            label: "Handle Events",
            path: ~p"/js-hook-map-handle-event",
            active: is_active?(current_path, ["/js-hook-map-handle-event"])
          }
        ]
      },
      %{
        expandable: %{
          id: "file-uploads",
          icon: "hero-arrow-up-tray",
          label: "File Uploads",
          open:
            is_active?(current_path, [
              "/upload",
              "/upload-cloud",
              "/upload-server"
            ])
        },
        expandable_items: [
          %{
            label: "File Uploads UI",
            path: ~p"/upload",
            active: is_active?(current_path, ["/upload"])
          },
          %{
            label: "File Uploads to Server",
            path: ~p"/upload-server",
            active: is_active?(current_path, ["/upload-server"])
          },
          %{
            label: "File Uploads to Cloud",
            path: ~p"/upload-cloud",
            active: is_active?(current_path, ["/upload-cloud"])
          }
        ]
      }
    ]
  end

  defp is_active?(current_path, paths) do
    if current_path in paths, do: true, else: false
  end
end
