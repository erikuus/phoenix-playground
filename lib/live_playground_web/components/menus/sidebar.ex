defmodule LivePlaygroundWeb.Menus.Sidebar do
  @moduledoc """
  Provides functionality for rendering the sidebar menu in the LivePlayground web application.

  This module uses Phoenix components for rendering and dynamically updates the menu based
  on the current layout to indicate which menu item is active.

  ## Assigns
  - `:current_layout`: The current layout (as an atom) indicating which menu item should be marked as active.
  """

  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: LivePlaygroundWeb.Endpoint,
    router: LivePlaygroundWeb.Router,
    statics: LivePlaygroundWeb.static_paths()

  import LivePlaygroundWeb.MoreComponents

  attr :current_layout, :atom

  @doc """
  Renders the sidebar menu with items based on the current layout.

  This function takes assigns containing the current layout context and uses it to determine
  the active menu item. The resulting menu is rendered using the `narrow_sidebar` component,
  which receives a list of menu items, each with an `:active` flag indicating its state.

  ## Parameters

  - assigns: A map containing the `:current_layout` which indicates the current page layout.

  ## Examples

      iex> LivePlaygroundWeb.Menus.Sidebar.menu(%{current_layout: :home})
      # Returns the HTML for the sidebar with the "Home" menu item marked as active.
  """
  def menu(assigns) do
    ~H"""
    <.narrow_sidebar items={get_items(@current_layout)} />
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
        icon: "hero-book-open",
        label: "Recipes",
        path: ~p"/click-buttons",
        layout: :recipes
      },
      %{
        icon: "hero-puzzle-piece",
        label: "Comps",
        path: ~p"/integration",
        layout: :comps
      },
      %{
        icon: "hero-check-circle",
        label: "Steps",
        path: ~p"/steps/generated",
        layout: :steps
      },
      %{
        icon: "hero-clipboard-document-check",
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
