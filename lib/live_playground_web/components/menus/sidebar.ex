defmodule LivePlaygroundWeb.Menus.Sidebar do
  use Phoenix.Component

  import LivePlaygroundWeb.MoreComponents

  attr :current_layout, :atom

  def menu(assigns) do
    ~H"""
    <.narrow_sidebar items={get_items(@current_layout)} />
    """
  end

  defp get_items(current_layout) do
    get_items() |> Enum.map(&Map.put(&1, :active, is_active?(current_layout, &1)))
  end

  defp get_items() do
    [
      %{
        icon: "hero-home",
        label: "Home",
        path: "/",
        layout: :home
      },
      %{
        icon: "hero-book-open",
        label: "Recipes",
        path: "/click-buttons",
        layout: :recipes
      },
      %{
        icon: "hero-rectangle-group",
        label: "Comps",
        path: "/modal",
        layout: :comps
      },
      %{
        icon: "hero-square-3-stack-3d",
        label: "Steps",
        path: "/languages",
        layout: :steps
      }
    ]
  end

  defp is_active?(current_layout, item) do
    if current_layout == item.layout, do: true, else: false
  end
end
