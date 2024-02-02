defmodule LivePlaygroundWeb.CompsLive.VerticalNavigationShowcase do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Full Functionality
      <:subtitle>
        How to utilize the full functionality of the Vertical Navigation Component
      </:subtitle>
      <:actions class="flex-col space-y-2 items-end">
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def vertical_navigation">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="w-80">
      <.vertical_navigation
        id="showcase"
        items={[
          %{
            section: %{
              label: "MORE COMPONENTS"
            },
            section_items: [
              %{
                icon: "hero-view-columns",
                label: "Multi-Column Layout",
                path: ~p"/multi-column-layout",
                active: false
              },
              %{
                icon: "hero-ellipsis-vertical",
                label: "Narrow Sidebar",
                path: ~p"/narrow-sidebar",
                active: false
              },
              %{
                expandable: %{
                  id: "vertical-navigation",
                  icon: "hero-list-bullet",
                  label: "Vertical Navigation",
                  open: true
                },
                expandable_items: [
                  %{
                    label: "Single Level Navigation",
                    path: ~p"/vertical-navigation",
                    active: true
                  },
                  %{
                    label: "Sectional Navigation",
                    path: ~p"/vertical-navigation-sections",
                    active: false
                  },
                  %{
                    label: "Expandable Navigation",
                    path: ~p"/vertical-navigation-expandable",
                    active: false
                  },
                  %{
                    label: "Full Functionality",
                    path: ~p"/vertical-navigation-showcase",
                    active: false
                  }
                ]
              }
            ]
          }
        ]}
      />
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/vertical_navigation_showcase.ex" />
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
