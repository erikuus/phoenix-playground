defmodule LivePlaygroundWeb.MainMenu do
  use Phoenix.Component

  import LivePlaygroundWeb.CoreComponents

  attr :current_path, :string

  def sidebar(assigns) do
    ~H"""
    <a
      :for={item <- items()}
      href={item.path}
      class={"#{item_bg_class(@current_path, item.path)} group flex w-full flex-col items-center rounded-md p-3 text-xs font-medium"}
      href="/clicks"
      class=""
    >
      <.icon name={item.icon} class="text-zinc-300 group-hover:text-white h-6 w-6" />
      <span class="mt-1 hidden md:block"><%= item.label %></span>
    </a>
    """
  end

  defp item_bg_class(current_path, item_path) do
    if current_path == item_path,
      do: "bg-zinc-800 text-white",
      else: "text-zinc-100 hover:bg-zinc-800 hover:text-white"
  end

  defp items() do
    [
      %{
        icon: "hero-home",
        label: "Home",
        path: "/"
      },
      %{
        icon: "hero-book-open",
        label: "Recipes",
        path: "/click-buttons"
      }
    ]
  end
end
