defmodule LivePlaygroundWeb.Comps do
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
        icon: "hero-arrow-top-right-on-square",
        label: "Modal",
        path: "/modal",
        badge: nil,
        paths: ["/modal"]
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
