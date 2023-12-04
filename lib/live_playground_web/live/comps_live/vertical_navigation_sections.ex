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
        <.link navigate={~p"/vertical-navigation-expandable"}>
          See also: Expandable Navigation <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="grid gap-6 grid-cols-1 sm:grid-cols-2 xl:gap-0 xl:grid-cols-3 xl:divide-x xl:divide-gray-100">
      <div class="space-y-1 xl:pr-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          Labels only
        </h2>
        <.vertical_navigation
          id="labels-only"
          items={[
            %{
              section: %{
                label: "CORE COMPONENTS"
              },
              section_items: [
                %{
                  label: "Header",
                  path: ~p"/header",
                  active: true
                },
                %{
                  label: "Button",
                  path: ~p"/button",
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
                  label: "Multi-Column Layout",
                  path: ~p"/multi-column-layout",
                  active: false
                },
                %{
                  label: "Narrow Sidebar",
                  path: ~p"/narrow-sidebar",
                  active: false
                }
              ]
            }
          ]}
        />
      </div>
      <div class="space-y-1 xl:px-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icons
        </h2>
        <.vertical_navigation
          id="with-cons"
          items={[
            %{
              section: %{
                label: "CORE COMPONENTS"
              },
              section_items: [
                %{
                  icon: "hero-queue-list",
                  label: "Header",
                  path: ~p"/header",
                  active: true
                },
                %{
                  icon: "hero-cursor-arrow-ripple",
                  label: "Button",
                  path: ~p"/button",
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
                }
              ]
            }
          ]}
        />
      </div>
      <div class="space-y-1 xl:px-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icons and badges
        </h2>
        <.vertical_navigation
          id="with-badges"
          items={[
            %{
              section: %{
                label: "CORE COMPONENTS"
              },
              section_items: [
                %{
                  icon: "hero-rectangle-stack",
                  label: "Flash",
                  path: ~p"/flash",
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
                  icon: "hero-bars-4",
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
          ]}
        />
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/vertical_navigation_sections.ex" />
      <.note icon="hero-information-circle">
        It would be helpful for you to look into how the vertical navigation component with sections works in this playground.
        The vertical navigation with sections is part of the
        <.github_link filename="lib/live_playground_web/components/menus/comps.ex">menu component</.github_link>,
        and it relies on a 'current path' attribute to determine the active menu item.
        The 'current path' value for the menu component is passed through the
        <.github_link filename="lib/live_playground_web/components/layouts/comps.html.heex">layout</.github_link>.
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
