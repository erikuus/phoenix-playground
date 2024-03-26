defmodule LivePlaygroundWeb.CompsLive.VerticalNavigationEnhanced do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Enhanced Navigation
      <:subtitle>
        How to Combine Sectioned and Expandable Elements for Optimal Navigation
      </:subtitle>
      <:actions class="flex-col space-y-2 items-end">
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def vertical_navigation">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="w-full sm:w-72">
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
                icon: "hero-list-bullet",
                label: "Narrow Sidebar",
                path: ~p"/narrow-sidebar",
                active: false
              },
              %{
                expandable: %{
                  id: "vertical-navigation",
                  icon: "hero-bars-3",
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
                    path: ~p"/vertical-navigation-enhanced",
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
      <.code_block filename="lib/live_playground_web/live/comps_live/vertical_navigation_enhanced.ex" />
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
