defmodule LivePlaygroundWeb.Recipes do
  use Phoenix.Component

  import LivePlaygroundWeb.MoreComponents

  attr :current_path, :string
  attr :text_class, :string, default: "text-sm"

  def menu(assigns) do
    ~H"""
    <.vertical_navigation items={items(@current_path)} text_class={@text_class} />
    """
  end

  defp items(current_path) do
    items() |> Enum.map(&Map.put(&1, :active, is_active?(current_path, &1)))
  end

  defp is_active?(current_path, item) do
    if current_path in item.paths, do: true, else: false
  end

  defp items() do
    [
      %{
        icon: "hero-cursor-arrow-ripple",
        label: "Click Buttons",
        path: "/click-buttons",
        badge: nil,
        paths: ["/click-buttons"]
      },
      %{
        icon: "hero-link",
        label: "Handle Params",
        path: "/handle-params",
        badge: nil,
        paths: ["/handle-params"]
      },
      %{
        icon: "hero-arrow-path-rounded-square",
        label: "Dynamic Form",
        path: "/dynamic-form",
        badge: nil,
        paths: ["/dynamic-form"]
      },
      %{
        icon: "hero-finger-print",
        label: "Key Events",
        path: "/key-events",
        badge: nil,
        paths: ["/key-events"]
      },
      %{
        icon: "hero-command-line",
        label: "JS Commands",
        path: "/js-commands",
        badge: nil,
        paths: ["/js-commands"]
      },
      %{
        icon: "hero-paper-airplane",
        label: "Send Messages",
        path: "/send-interval",
        badge: 2,
        paths: ["/send-interval", "/send-after"]
      },
      %{
        icon: "hero-queue-list",
        label: "Autocomplete",
        path: "/autocomplete",
        badge: 2,
        paths: ["/autocomplete", "/autocomplete-custom"]
      },
      %{
        icon: "hero-magnifying-glass",
        label: "Search",
        path: "/search",
        badge: 2,
        paths: ["/search", "/search-param"]
      },
      %{
        icon: "hero-funnel",
        label: "Filtering",
        path: "/filter",
        badge: 2,
        paths: ["/filter", "/filter-params"]
      },
      %{
        icon: "hero-arrows-up-down",
        label: "Sorting",
        path: "/sort",
        badge: 2,
        paths: ["/sort", "/sort-params"]
      },
      %{
        icon: "hero-arrows-right-left",
        label: "Pagination",
        path: "/paginate",
        badge: 2,
        paths: ["/paginate", "/paginate-params"]
      },
      %{
        icon: "hero-pencil-square",
        label: "Form",
        path: "/form-insert",
        badge: 2,
        paths: ["/form-insert", "/form-insert-validate", "/form-update"]
      },
      %{
        icon: "hero-rss",
        label: "Stream",
        path: "/stream-insert",
        badge: 2,
        paths: ["/stream-insert", "/stream-update"]
      },
      %{
        icon: "hero-signal",
        label: "Broadcast",
        path: "/broadcast",
        badge: 2,
        paths: ["/broadcast", "/broadcast-stream"]
      },
      %{
        icon: "hero-table-cells",
        label: "Tabular Insert",
        path: "/tabular-insert",
        badge: nil,
        paths: ["/tabular-insert"]
      },
      %{
        icon: "hero-arrow-up-tray",
        label: "Upload",
        path: "/upload",
        badge: nil,
        paths: ["/upload"]
      }
    ]
  end
end
