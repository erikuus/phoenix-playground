defmodule LivePlaygroundWeb.RecipesMenu do
  use Phoenix.Component

  import LivePlaygroundWeb.CoreComponents

  def mobile(assigns) do
    ~H"""
    <.link
      :for={item <- items()}
      navigate={item.path}
      class="hover:bg-gray-100 text-gray-600 group flex items-center px-2 py-2 text-base font-medium rounded-md"
    >
      <.icon name={item.icon} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" />
      <span class="flex-1"><%= item.label %></span>
      <span
        :if={item.badge}
        class="bg-gray-100 group-hover:bg-gray-200 ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full"
      >
        <%= item.badge %>
      </span>
    </.link>
    """
  end

  attr :current_path, :string

  def desktop(assigns) do
    ~H"""
    <.link
      :for={item <- items()}
      navigate={item.path}
      class={"#{item_bg_class(@current_path, item.paths)} text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md"}
    >
      <.icon name={item.icon} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" />
      <span class="flex-1"><%= item.label %></span>
      <span
        :if={item.badge}
        class={"#{badge_bg_class(@current_path, item.paths)} ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full"}
      >
        <%= item.badge %>
      </span>
    </.link>
    """
  end

  defp item_bg_class(current_path, item_paths) do
    if current_path in item_paths, do: "bg-gray-100", else: "hover:bg-gray-100"
  end

  defp badge_bg_class(current_path, item_paths) do
    if current_path in item_paths, do: "bg-gray-200", else: "bg-gray-100 group-hover:bg-gray-200"
  end

  defp items() do
    [
      %{
        icon: "hero-cursor-arrow-ripple",
        label: "Click Buttons",
        path: "/click-buttons",
        badge: nil,
        paths: ["/clicks"]
      },
      %{
        icon: "hero-link",
        label: "Handle Params",
        path: "/handle-params",
        badge: nil,
        paths: ["/params"]
      },
      %{
        icon: "hero-arrow-path",
        label: "Dynamic Form",
        path: "/dynamic-form",
        badge: nil,
        paths: ["/changes"]
      },
      %{
        icon: "hero-arrow-top-right-on-square",
        label: "Modals",
        path: "/modals",
        badge: nil,
        paths: ["/modals"]
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
        paths: ["/paginate", "paginate-params"]
      },
      %{
        icon: "hero-pencil-square",
        label: "Form",
        path: "/form-insert",
        badge: 2,
        paths: ["/form-insert", "/form-insert-validate", "/form-update"]
      },
      %{
        icon: "hero-squares-plus",
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
        icon: "hero-arrow-up-tray",
        label: "Upload",
        path: "/upload",
        badge: nil,
        paths: ["/upload"]
      }
    ]
  end
end