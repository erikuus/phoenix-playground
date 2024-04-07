defmodule LivePlaygroundWeb.CompsLive.VerticalNavigation do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Single Level Navigation
      <:subtitle>
        Implementing Single Level Vertical Navigation in LiveView
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
    <div class="w-full sm:w-72">
      <.vertical_navigation
        id="single-level"
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
          }
        ]}
      />
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
