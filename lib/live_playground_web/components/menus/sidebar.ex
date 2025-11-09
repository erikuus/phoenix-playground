defmodule LivePlaygroundWeb.Menus.Sidebar do
  @moduledoc """
  Provides functionality for rendering the sidebar menu in the LivePlayground web application.

  This module uses Phoenix components for rendering and dynamically updates the menu based
  on the current layout to indicate which menu item is active.

  ## Special Implementation Note

  The sidebar implements a split authentication pattern where the auth_menu component is used
  twice in different locations:
  - Guest users: Login/signup buttons appear in the layout header (see home.html.heex)
  - Authenticated users: Avatar menu appears at the bottom of the sidebar (rendered here)

  This pattern provides optimal UX by placing guest CTAs prominently in the header while keeping
  the authenticated user menu accessible in the persistent sidebar.

  ## Assigns
  - `:current_layout`: The current layout (as an atom) indicating which menu item should be marked as active.
  - `:current_user`: The authenticated user (map) or nil for guest users.
  """

  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: LivePlaygroundWeb.Endpoint,
    router: LivePlaygroundWeb.Router,
    statics: LivePlaygroundWeb.static_paths()

  import LivePlaygroundWeb.MoreComponents

  attr :current_layout, :atom
  attr :current_user, :map, default: nil

  @doc """
  Renders the sidebar menu with items and optional authentication menu.

  This function takes assigns containing the current layout context and current user to render
  the sidebar. The sidebar consists of two parts:
  - Navigation menu items with the active item marked based on the current layout
  - Authentication menu (avatar-only) displayed at the bottom when user is authenticated

  ## Parameters

  - assigns: A map containing:
    - `:current_layout` - The current page layout (atom) to determine active menu item
    - `:current_user` - The authenticated user (map) or nil for guest users

  ## Examples

      iex> LivePlaygroundWeb.Menus.Sidebar.menu(%{current_layout: :home, current_user: nil})
      # Returns the HTML for the sidebar with the "Home" menu item marked as active and no auth menu

      iex> LivePlaygroundWeb.Menus.Sidebar.menu(%{current_layout: :recipes, current_user: %{email: "user@example.com"}})
      # Returns the HTML for the sidebar with "Recipes" active and avatar menu at the bottom
  """
  def menu(assigns) do
    ~H"""
    <div class="flex h-full w-full flex-col items-center">
      <div class="w-full flex-1 overflow-y-auto">
        <.narrow_sidebar items={get_items(@current_layout)} />
      </div>
      <div :if={@current_user} class="pb-2">
        <.auth_menu
          id="auth-menu-sidebar"
          class="flex justify-center"
          avatar_only={true}
          avatar_class="w-12 h-12 border-2 border-zinc-600 hover:border-zinc-400"
          avatar_color="text-zinc-100 hover:bg-zinc-600 hover:bg-opacity-50 hover:text-white"
          dropdown_position="top-left"
          current_user={@current_user}
        />
      </div>
    </div>
    """
  end

  # Internal function to retrieve and mark the active item based on the current layout.
  defp get_items(current_layout) do
    get_items() |> Enum.map(&Map.put(&1, :active, is_active?(current_layout, &1)))
  end

  # Retrieves the predefined list of menu items.
  defp get_items() do
    [
      %{
        icon: "hero-home",
        label: "Home",
        path: ~p"/",
        layout: :home
      },
      %{
        icon: "hero-puzzle-piece",
        label: "Comps",
        path: ~p"/comps-setup",
        layout: :comps
      },
      %{
        icon: "hero-book-open",
        label: "Recipes",
        path: ~p"/recipes-introduction",
        layout: :recipes
      },
      %{
        icon: "hero-chart-bar",
        label: "Steps",
        path: ~p"/steps/introduction",
        layout: :steps
      },
      %{
        icon: "hero-clipboard-document-list",
        label: "Rules",
        path: ~p"/rules",
        layout: :page
      }
    ]
  end

  # Determines if a menu item is active based on the current layout.
  defp is_active?(current_layout, item) do
    current_layout == item.layout
  end
end
