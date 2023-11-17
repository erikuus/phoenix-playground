defmodule LivePlaygroundWeb.CompsLive.NarrowSidebarDemo do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {LivePlaygroundWeb.Layouts, :app}}
  end

  def render(assigns) do
    ~H"""
    <div class="fixed inset-y-0 bg-zinc-700 w-14 md:w-20 pl-1.5 pr-1.5 py-1.5 space-y-1">
      <.narrow_sidebar items={[
        %{
          icon: "hero-home",
          label: "Home",
          path: "/",
          active: true
        },
        %{
          icon: "hero-book-open",
          label: "Recipes",
          path: "/click-buttons",
          active: false
        },
        %{
          icon: "hero-rectangle-group",
          label: "Comps",
          path: "/modal",
          active: false
        },
        %{
          icon: "hero-square-3-stack-3d",
          label: "Steps",
          path: "/languages",
          active: false
        }
      ]} />
    </div>
    """
  end
end
