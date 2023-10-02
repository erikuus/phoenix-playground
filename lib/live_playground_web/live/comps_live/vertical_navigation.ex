defmodule LivePlaygroundWeb.CompsLive.VerticalNavigation do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Vertical Navigation
      <:subtitle>
        How to use vertical navigation component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def vertical_navigation">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="grid gap-6 grid-cols-1 sm:grid-cols-2 xl:gap-0 xl:grid-cols-4 xl:divide-x xl:divide-gray-100">
      <div class="space-y-1 xl:pr-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With text only
        </h2>
        <.vertical_navigation items={[
          %{
            label: "Click Buttons",
            path: "/click-buttons",
            active: true
          },
          %{
            label: "Handle Params",
            path: "/handle-params",
            active: false
          },
          %{
            label: "Change Form",
            path: "/change-form",
            active: false
          },
          %{
            label: "Key Events",
            path: "/key-events",
            active: false
          },
          %{
            label: "JS Commands",
            path: "/js-commands",
            active: false
          }
        ]} />
      </div>
      <div class="space-y-1 xl:px-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icons
        </h2>
        <.vertical_navigation items={[
          %{
            icon: "hero-cursor-arrow-ripple",
            label: "Click Buttons",
            path: "/click-buttons",
            active: true
          },
          %{
            icon: "hero-link",
            label: "Handle Params",
            path: "/handle-params",
            active: false
          },
          %{
            icon: "hero-arrow-path-rounded-square",
            label: "Change Form",
            path: "/change-form",
            active: false
          },
          %{
            icon: "hero-cube",
            label: "Key Events",
            path: "/key-events",
            active: false
          },
          %{
            icon: "hero-command-line",
            label: "JS Commands",
            path: "/js-commands",
            active: false
          }
        ]} />
      </div>
      <div class="space-y-1 xl:px-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icons and badges
        </h2>
        <.vertical_navigation items={[
          %{
            icon: "hero-paper-airplane",
            label: "Send Messages",
            path: "/send-interval",
            badge: 2,
            active: true
          },
          %{
            icon: "hero-queue-list",
            label: "Autocomplete",
            path: "/autocomplete",
            badge: 2,
            active: false
          },
          %{
            icon: "hero-magnifying-glass",
            label: "Search",
            path: "/search",
            badge: 2,
            active: false
          },
          %{
            icon: "hero-funnel",
            label: "Filtering",
            path: "/filter",
            badge: 2,
            active: false
          },
          %{
            icon: "hero-arrows-up-down",
            label: "Sorting",
            path: "/sort",
            badge: 2,
            active: false
          }
        ]} />
      </div>
      <div class="space-y-1 xl:pl-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With custom colors
        </h2>
        <.vertical_navigation
          item_class="text-gray-700 hover:text-indigo-600 hover:bg-gray-50"
          item_active_class="bg-gray-50 text-indigo-600"
          icon_class="text-gray-400 group-hover:text-indigo-600"
          icon_active_class="text-indigo-600"
          badge_class="bg-white text-gray-600 ring-1 ring-inset ring-gray-200"
          badge_active_class="bg-white text-gray-600 ring-1 ring-inset ring-gray-200"
          items={[
            %{
              icon: "hero-paper-airplane",
              label: "Send Messages",
              path: "/send-interval",
              badge: 2,
              active: true
            },
            %{
              icon: "hero-queue-list",
              label: "Autocomplete",
              path: "/autocomplete",
              badge: 2,
              active: false
            },
            %{
              icon: "hero-magnifying-glass",
              label: "Search",
              path: "/search",
              badge: 2,
              active: false
            },
            %{
              icon: "hero-funnel",
              label: "Filtering",
              path: "/filter",
              badge: 2,
              active: false
            },
            %{
              icon: "hero-arrows-up-down",
              label: "Sorting",
              path: "/sort",
              badge: 2,
              active: false
            }
          ]}
        />
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/vertical_navigation.ex" />
      <.note icon="hero-information-circle">
        It would be helpful for you to look into how the vertical navigation component works in this playground.
        The vertical navigation is part of the
        <.github_link filename="lib/live_playground_web/components/menus/recipes.ex">menu component</.github_link>,
        and it relies on a 'current path' attribute to determine the active menu item.
        The 'current path' value for the menu component is passed through the
        <.github_link filename="lib/live_playground_web/components/layouts/recipes.html.heex">layout</.github_link>.
        This value can be set in the layout because it's assigned in a special
        <.github_link filename="lib/live_playground_web/live/init_live.ex">initialization module</.github_link>
        that's mounted on a session in the
        <.github_link filename="lib/live_playground_web/router.ex">router</.github_link>.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
