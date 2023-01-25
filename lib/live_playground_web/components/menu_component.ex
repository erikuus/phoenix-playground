defmodule LivePlaygroundWeb.MenuComponent do
  use LivePlaygroundWeb, :component

  import LivePlaygroundWeb.IconComponent

  def desktop(assigns) do
    ~H"""
    <%= for item <- items() do %>
    <a href={"#{item.path}"} class={"#{bg_class(item.path, @current_path)} text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md"}>
      <.icon name={"#{item.icon}"} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" />
      <%= item.label %>
    </a>
    <% end  %>
    """
  end

  def mobile(assigns) do
    ~H"""
    <%= for item <- items() do %>
    <a href={"#{item.path}"} class={"#{bg_class(item.path, @current_path)} text-gray-600 group flex items-center px-2 py-2 text-base font-medium rounded-md"}>
      <.icon name={"#{item.icon}"} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" />
      <%= item.label %>
    </a>
    <% end  %>
    """
  end

  defp items() do
    [
      %{icon: "home", label: "Home", path: "/"},
      %{icon: "cursor_arrow_ripple", label: "Clicks", path: "/clicks"},
      %{icon: "arrow_path", label: "Changes", path: "/changes"},
      %{icon: "clock", label: "Send Interval", path: "/send-interval"},
      %{icon: "paper_airplane", label: "Send After", path: "/send-after"},
      %{icon: "rectangle_stack", label: "Modals", path: "/modals"},
      %{icon: "arrow_up_tray", label: "Upload", path: "/upload"},
      %{icon: "cloud_arrow_up", label: "Cloud Upload", path: "/upload-cloud"}
    ]
  end

  defp bg_class(item_path, current_path) do
    if item_path == current_path, do: "bg-gray-100", else: "hover:bg-gray-100"
  end
end
