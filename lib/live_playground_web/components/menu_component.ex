defmodule LivePlaygroundWeb.MenuComponent do
  use LivePlaygroundWeb, :component

  import LivePlaygroundWeb.IconComponent

  def desktop(assigns) do
    ~H"""
    <a :for={item <- items()} href={"#{item.path}"} class={"#{item_bg_class(item.path, @current_path)} text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md"}>
      <.icon name={"#{item.icon}"} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" />
      <span class="flex-1"><%= item.label %></span>
      <span :if={item.badge} class={"#{badge_bg_class(item.path, @current_path)} ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full"}><%= item.badge %></span>
    </a>

    """
  end

  def mobile(assigns) do
    ~H"""
    <a :for={item <- items()} href={"#{item.path}"} class={"#{item_bg_class(item.path, @current_path)} text-gray-600 group flex items-center px-2 py-2 text-base font-medium rounded-md"}>
      <.icon name={"#{item.icon}"} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" />
      <span class="flex-1"><%= item.label %></span>
      <span :if={item.badge} class={"#{badge_bg_class(item.path, @current_path)} ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full"}><%= item.badge %></span>
    </a>
    """
  end

  defp items() do
    [
      %{icon: "home", label: "Home", path: "/", badge: nil},
      %{icon: "cursor_arrow_ripple", label: "Clicks", path: "/clicks", badge: nil},
      %{icon: "arrow_path", label: "Changes", path: "/changes", badge: nil},
      %{icon: "clock", label: "Send Interval", path: "/send-interval", badge: nil},
      %{icon: "paper_airplane", label: "Send After", path: "/send-after", badge: nil},
      %{icon: "queue_list", label: "Autocomplete", path: "/autocomplete", badge: 2},
      %{icon: "magnifying_glass", label: "Search", path: "/search", badge: 2},
      %{icon: "funnel", label: "Filter", path: "/filter", badge: nil},
      %{icon: "rectangle_stack", label: "Modals", path: "/modals", badge: nil},
      %{icon: "arrow_up_tray", label: "Upload", path: "/upload", badge: nil},
      %{icon: "cloud_arrow_up", label: "Cloud Upload", path: "/upload-cloud", badge: nil}
    ]
  end

  defp item_bg_class(item_path, current_path) do
    if item_path == current_path, do: "bg-gray-100", else: "hover:bg-gray-100"
  end

  defp badge_bg_class(item_path, current_path) do
    if item_path == current_path, do: "bg-gray-200", else: "bg-gray-100 group-hover:bg-gray-200"
  end
end
