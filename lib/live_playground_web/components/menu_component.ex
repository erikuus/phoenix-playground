defmodule LivePlaygroundWeb.MenuComponent do
  use Phoenix.Component

  import LivePlaygroundWeb.CoreComponents

  def desktop(assigns) do
    ~H"""
    <.link
      :for={item <- items()}
      href={item.path}
      class={"#{item_bg_class(item.path, @current_path)} text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md"}
    >
      <.icon name={item.icon} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" />
      <span class="flex-1"><%= item.label %></span>
      <span :if={item.badge} class={"#{badge_bg_class(item.path, @current_path)} ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full"}>
        <%= item.badge %>
      </span>
    </.link>
    """
  end

  def mobile(assigns) do
    ~H"""
    <.link
      :for={item <- items()}
      href={item.path}
      class={"#{item_bg_class(item.path, @current_path)} text-gray-600 group flex items-center px-2 py-2 text-base font-medium rounded-md"}
    >
      <.icon name={item.icon} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" />
      <span class="flex-1"><%= item.label %></span>
      <span :if={item.badge} class={"#{badge_bg_class(item.path, @current_path)} ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full"}>
        <%= item.badge %>
      </span>
    </.link>
    """
  end

  defp items() do
    [
      %{icon: "hero-home", label: "Home", path: "/", badge: nil},
      %{icon: "hero-cursor-arrow-ripple", label: "Clicks", path: "/clicks", badge: nil},
      %{icon: "hero-arrow-path", label: "Changes", path: "/changes", badge: nil},
      %{icon: "hero-link", label: "Navigate", path: "/navigate", badge: nil},
      %{icon: "hero-paper-airplane", label: "Send", path: "/send-interval", badge: 2},
      %{icon: "hero-queue-list", label: "Autocomplete", path: "/autocomplete", badge: 2},
      %{icon: "hero-magnifying-glass", label: "Search", path: "/search", badge: 2},
      %{icon: "hero-funnel", label: "Filter", path: "/filter", badge: 2},
      %{icon: "hero-rectangle-stack", label: "Modals", path: "/modals", badge: 2},
      %{icon: "hero-arrow-up-tray", label: "Upload", path: "/upload", badge: nil}
    ]
  end

  defp item_bg_class(item_path, current_path) do
    if item_path == current_path, do: "bg-gray-100", else: "hover:bg-gray-100"
  end

  defp badge_bg_class(item_path, current_path) do
    if item_path == current_path, do: "bg-gray-200", else: "bg-gray-100 group-hover:bg-gray-200"
  end
end
