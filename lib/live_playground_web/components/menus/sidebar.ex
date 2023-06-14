defmodule LivePlaygroundWeb.Sidebar do
  use Phoenix.Component

  import LivePlaygroundWeb.CoreComponents

  attr :current_layout, :atom

  def menu(assigns) do
    ~H"""
    <.link
      :for={item <- items()}
      navigate={item.path}
      class={"#{item_bg_class(@current_layout, item.layout)} group flex w-full flex-col items-center rounded-md p-3 text-xs font-medium"}
    >
      <.icon name={item.icon} class="text-zinc-300 group-hover:text-white h-6 w-6" />
      <span class="mt-1 hidden md:block"><%= item.label %></span>
    </.link>
    """
  end

  defp item_bg_class(current_layout, item_layout) do
    if current_layout == item_layout,
      do: "bg-zinc-600 bg-opacity-50 text-white",
      else: "text-zinc-100 hover:bg-zinc-600 hover:bg-opacity-50 hover:text-white"
  end

  defp items() do
    [
      %{
        icon: "hero-home",
        label: "Home",
        path: "/",
        layout: :home
      },
      %{
        icon: "hero-square-3-stack-3d",
        label: "Recipes",
        path: "/click-buttons",
        layout: :recipes
      },
      %{
        icon: "hero-rectangle-group",
        label: "Comps",
        path: "/modals",
        layout: :comps
      }
    ]
  end
end
