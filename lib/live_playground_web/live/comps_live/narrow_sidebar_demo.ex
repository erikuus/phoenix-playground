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

    <div class="fixed inset-y-0 ml-24 sm:ml-32 bg-indigo-600 w-14 md:w-20 pl-1.5 pr-1.5 py-1.5 space-y-1">
      <.narrow_sidebar
        item_class="text-indigo-100 hover:bg-indigo-500 hover:bg-opacity-50 hover:text-white"
        item_active_class="bg-indigo-500 bg-opacity-50 text-white"
        items={[
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
        ]}
      />
    </div>

    <div class={[
      "fixed inset-y-0 ml-48 sm:ml-64 w-14 md:w-20 pl-1.5 pr-1.5 py-1.5 space-y-1",
      "bg-gradient-to-br from-[#FF80B5] to-[#9089FC] opacity-60"
    ]}>
      <.narrow_sidebar
        item_class="hover:backdrop-filter hover:backdrop-brightness-90 text-white"
        item_active_class="backdrop-filter backdrop-brightness-90 text-white"
        items={[
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
        ]}
      />
    </div>
    """
  end
end
