defmodule LivePlaygroundWeb.Menus.Recipes do
  use Phoenix.Component

  import LivePlaygroundWeb.MoreComponents

  attr :current_path, :string

  def menu(assigns) do
    ~H"""
    <.vertical_navigation items={get_items(@current_path)} />
    """
  end

  defp get_items(current_path) do
    [
      %{
        icon: "hero-cursor-arrow-ripple",
        label: "Click Buttons",
        path: "/click-buttons",
        active: is_active?(current_path, ["/click-buttons"])
      },
      %{
        icon: "hero-link",
        label: "Handle Params",
        path: "/handle-params",
        active: is_active?(current_path, ["/handle-params"])
      },
      %{
        icon: "hero-arrow-path-rounded-square",
        label: "Change Form",
        path: "/change-form",
        active: is_active?(current_path, ["/change-form"])
      },
      %{
        icon: "hero-cube",
        label: "Key Events",
        path: "/key-events",
        active: is_active?(current_path, ["/key-events"])
      },
      %{
        icon: "hero-command-line",
        label: "JS Commands",
        path: "/js-commands",
        active: is_active?(current_path, ["/js-commands"])
      },
      %{
        icon: "hero-paper-airplane",
        label: "Send Messages",
        path: "/send-interval",
        badge: 2,
        active:
          is_active?(current_path, [
            "/send-interval",
            "/send-after"
          ])
      },
      %{
        icon: "hero-queue-list",
        label: "Autocomplete",
        path: "/autocomplete",
        badge: 2,
        active:
          is_active?(current_path, [
            "/autocomplete",
            "/autocomplete-custom"
          ])
      },
      %{
        icon: "hero-magnifying-glass",
        label: "Search",
        path: "/search",
        badge: 2,
        active:
          is_active?(current_path, [
            "/search",
            "/search-param"
          ])
      },
      %{
        icon: "hero-funnel",
        label: "Filtering",
        path: "/filter",
        badge: 2,
        active:
          is_active?(current_path, [
            "/filter",
            "/filter-params"
          ])
      },
      %{
        icon: "hero-arrows-up-down",
        label: "Sorting",
        path: "/sort",
        badge: 2,
        active:
          is_active?(current_path, [
            "/sort",
            "/sort-params"
          ])
      },
      %{
        icon: "hero-arrows-right-left",
        label: "Pagination",
        path: "/paginate",
        badge: 2,
        active:
          is_active?(current_path, [
            "/paginate",
            "/paginate-params"
          ])
      },
      %{
        icon: "hero-pencil-square",
        label: "Form",
        path: "/form-insert",
        badge: 2,
        active:
          is_active?(current_path, [
            "/form-insert",
            "/form-insert-validate",
            "/form-update"
          ])
      },
      %{
        icon: "hero-rss",
        label: "Stream",
        path: "/stream-insert",
        badge: 3,
        active:
          is_active?(current_path, [
            "/stream-insert",
            "/stream-update",
            "/stream-reset"
          ])
      },
      %{
        icon: "hero-signal",
        label: "Broadcast",
        path: "/broadcast",
        badge: 2,
        active:
          is_active?(current_path, [
            "/broadcast",
            "/broadcast-stream"
          ])
      },
      %{
        icon: "hero-table-cells",
        label: "Tabular Insert",
        path: "/tabular-insert",
        active: is_active?(current_path, ["/tabular-insert"])
      },
      %{
        icon: "hero-map",
        label: "JS Hooks",
        path: "/js-hook-map-dataset",
        badge: 3,
        active:
          is_active?(current_path, [
            "/js-hook-map-dataset",
            "/js-hook-map-push-event",
            "/js-hook-map-handle-event"
          ])
      },
      %{
        icon: "hero-arrow-up-tray",
        label: "File Uploads",
        path: "/upload",
        badge: 3,
        active:
          is_active?(current_path, [
            "/upload",
            "/upload-cloud",
            "/upload-server"
          ])
      }
    ]
  end

  defp is_active?(current_path, paths) do
    if current_path in paths, do: true, else: false
  end
end
