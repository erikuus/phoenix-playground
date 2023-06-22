defmodule LivePlaygroundWeb.Layouts do
  use LivePlaygroundWeb, :html

  alias LivePlaygroundWeb.Menus.Sidebar
  alias LivePlaygroundWeb.Menus.Recipes
  alias LivePlaygroundWeb.Menus.Comps
  alias LivePlaygroundWeb.Menus.Steps

  embed_templates "layouts/*"
end
