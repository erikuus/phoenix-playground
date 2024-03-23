defmodule LivePlaygroundWeb.CompsLive.VerticalNavigationSections do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Sectional Navigation
      <:subtitle>
        How to use Vertical Navigation component for Sectional Navigation
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
        id="sectional"
        items={
          [
            %{
              section: %{
                label: "CORE COMPONENTS"
              },
              section_items: [
                %{
                  icon: "hero-rectangle-stack",
                  label: "Flash",
                  path: ~p"/flash-auto-show",
                  badge: 5,
                  active: true
                },
                %{
                  icon: "hero-window",
                  label: "Modal",
                  path: ~p"/modal",
                  badge: 6,
                  active: false
                }
              ]
            },
            %{
              section: %{
                label: "MORE COMPONENTS"
              },
              section_items: [
                %{
                  icon: "hero-bars-3",
                  label: "Vertical Navigation",
                  path: ~p"/vertical-navigation",
                  badge: 4,
                  active: false
                },
                %{
                  icon: "hero-arrow-right-on-rectangle",
                  label: "Slideover",
                  path: ~p"/slideover",
                  badge: 6,
                  active: false
                }
              ]
            }
          ]
        }
      />
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/vertical_navigation_sections.ex" />
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
