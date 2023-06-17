defmodule LivePlaygroundWeb.Layouts do
  use LivePlaygroundWeb, :html

  alias LivePlaygroundWeb.Menus.Sidebar
  alias LivePlaygroundWeb.Menus.Recipes
  alias LivePlaygroundWeb.Menus.Comps

  embed_templates "layouts/*"
end
