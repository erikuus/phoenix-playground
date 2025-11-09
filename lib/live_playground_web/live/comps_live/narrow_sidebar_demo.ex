defmodule LivePlaygroundWeb.CompsLive.NarrowSidebarDemo do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {LivePlaygroundWeb.Layouts, :app}}
  end

  def render(assigns) do
    ~H"""
    <div class="fixed inset-y-0 bg-zinc-700 w-14 md:w-20 pl-1.5 pr-1.5 py-1.5">
      <.narrow_sidebar items={[
        %{
          icon: "hero-home",
          label: "Home",
          path: "/narrow-sidebar-demo",
          active: true
        },
        %{
          icon: "hero-book-open",
          label: "Recipes",
          path: "/narrow-sidebar-demo",
          active: false
        },
        %{
          icon: "hero-rectangle-group",
          label: "Comps",
          path: "/narrow-sidebar-demo",
          active: false
        },
        %{
          icon: "hero-square-3-stack-3d",
          label: "Steps",
          path: "/narrow-sidebar-demo",
          active: false
        }
      ]} />
    </div>
    """
  end
end
