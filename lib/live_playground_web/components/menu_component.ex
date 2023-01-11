defmodule LivePlaygroundWeb.MenuComponent do
  use LivePlaygroundWeb, :component

  def desktop(assigns) do
    ~H"""
    <%= for item <- items() do %>
    <a href={"#{item.path}"} class={"#{bg_class(item.path, @current_path)} text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md"}>
      <%= raw(item.icon.("text-gray-500 mr-3 flex-shrink-0 h-6 w-6")) %>
      <%= item.label %>
    </a>
    <% end  %>
    """
  end

  def mobile(assigns) do
    ~H"""
    <%= for item <- items() do %>
    <a href={"#{item.path}"} class="text-gray-600 hover:bg-gray-50 hover:text-gray-900 group flex items-center px-2 py-2 text-base font-medium rounded-md">
      <%= raw(item.icon.("text-gray-500 mr-3 flex-shrink-0 h-6 w-6")) %>
      <%= item.label %>
    </a>
    <% end  %>
    """
  end

  defp items() do
    [
      %{icon: &svg_icon_home(&1), label: "Home", path: "/"},
      %{icon: &svg_icon_cursor_arrow_ripple(&1), label: "Clicks", path: "/clicks"},
      %{icon: &svg_icon_rectangle_stack(&1), label: "Modals", path: "/modals"},
      %{icon: &svg_icon_arrow_up_tray(&1), label: "Upload", path: "/upload"},
      %{icon: &svg_icon_cloud_arrow_up(&1), label: "Cloud Upload", path: "/upload-cloud"}
    ]
  end

  defp bg_class(item_path, current_path) do
    if item_path == current_path, do: "bg-gray-100", else: "hover:bg-gray-100"
  end
end
