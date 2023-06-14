defmodule LivePlaygroundWeb.Comps do
  use Phoenix.Component

  import LivePlaygroundWeb.CoreComponents

  attr :current_path, :string
  attr :text_class, :string, default: "text-sm"

  def menu(assigns) do
    ~H"""
    <.link
      :for={item <- items()}
      navigate={item.path}
      class={[
        "text-gray-900 group flex items-center px-2 py-2 font-medium rounded-md",
        item_bg_class(@current_path, item.paths),
        @text_class
      ]}
    >
      <.icon name={item.icon} class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" /> <span class="flex-1"><%= item.label %></span>
      <span
        :if={item.badge}
        class={["ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full", badge_bg_class(@current_path, item.paths)]}
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
        icon: "hero-arrow-top-right-on-square",
        label: "Modals",
        path: "/modals",
        badge: nil,
        paths: ["/modals"]
      },
      %{
        icon: "hero-arrow-up-tray",
        label: "Slideover",
        path: "/slideover",
        badge: nil,
        paths: ["/slideover"]
      }
    ]
  end
end
