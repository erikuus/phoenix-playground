defmodule LivePlaygroundWeb.CompsLive.VerticalNavigation do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Single Level Navigation
      <:subtitle>
        How to use Vertical Navigation component for Single Level Navigation
      </:subtitle>
      <:actions class="flex-col space-y-2 items-end">
        <.goto_definition
          filename="lib/live_playground_web/components/more_components.ex"
          definition="def vertical_navigation(assigns)"
        >
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="grid gap-6 grid-cols-1 md:grid-cols-3 md:gap-0 md:divide-x md:divide-gray-100">
      <div class="space-y-1 md:pr-3 xl:pr-6 2xl:pr-9">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          Labels only
        </h2>
        <.vertical_navigation
          id="labels-only"
          items={[
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
          ]}
        />
      </div>
      <div class="space-y-1 md:px-3 xl:px-6 2xl:px-9">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icons
        </h2>
        <.vertical_navigation
          id="with-icons"
          items={[
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
          ]}
        />
      </div>
      <div class="space-y-1 md:px-3 xl:px-6 2xl:px-9">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icons and badges
        </h2>
        <.vertical_navigation
          id="with-badges"
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
