defmodule LivePlaygroundWeb.CompsLive.VerticalNavigationExpandable do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Expandable Navigation
      <:subtitle>
        How to use Vertical Navigation component for Expandable Navigation
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
        id="expandable"
        items={[
          %{
            expandable: %{
              id: "send-messages",
              icon: "hero-paper-airplane",
              label: "Send Messages",
              badge: 2,
              open: true
            },
            expandable_items: [
              %{
                label: "Send Repeatedly",
                path: ~p"/send-interval",
                active: false
              },
              %{
                label: "Send After",
                path: ~p"/send-after",
                active: false
              }
            ]
          },
          %{
            expandable: %{
              id: "autocomplete",
              icon: "hero-bars-arrow-down",
              label: "Autocomplete",
              badge: 2,
              open: false
            },
            expandable_items: [
              %{
                label: "Native Autocomplete",
                path: ~p"/autocomplete",
                active: false
              },
              %{
                label: "Custom Autocomplete",
                path: ~p"/autocomplete-custom",
                active: false
              }
            ]
          },
          %{
            expandable: %{
              id: "search",
              icon: "hero-magnifying-glass",
              label: "Search",
              badge: 2,
              open: false
            },
            expandable_items: [
              %{
                label: "Handle-event Search",
                path: ~p"/search",
                active: false
              },
              %{
                label: "Handle-params Search",
                path: ~p"/search-param",
                active: false
              }
            ]
          }
        ]}
      />
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/vertical_navigation_expandable.ex" />
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
