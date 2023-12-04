defmodule LivePlaygroundWeb.CompsLive.VerticalNavigationExpandable do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

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
        <.link navigate={~p"/vertical-navigation"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Single Level Navigation
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
              expandable: %{
                id: "send-messages",
                label: "Send Messages",
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
                label: "Autocomplete",
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
                label: "Search",
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
      <div class="space-y-1 xl:px-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icons
        </h2>
        <.vertical_navigation
          id="with-cons"
          items={[
            %{
              expandable: %{
                id: "send-messages",
                icon: "hero-paper-airplane",
                label: "Send Messages",
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
      <div class="space-y-1 xl:px-4">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icons and badges
        </h2>
        <.vertical_navigation
          id="with-badges"
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
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/vertical_navigation_expandable.ex" />
      <.note icon="hero-information-circle">
        It would be helpful for you to look into how the vertical navigation component with expandale sections works in this playground.
        The vertical navigation with expandale sections is part of the
        <.github_link filename="lib/live_playground_web/components/menus/comps.ex">menu component</.github_link>,
        and it relies on a 'current path' attribute to determine open and active menu items.
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
