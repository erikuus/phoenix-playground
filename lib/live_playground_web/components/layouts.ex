defmodule LivePlaygroundWeb.Layouts do
  use LivePlaygroundWeb, :html

  alias LivePlaygroundWeb.Sidebar
  alias LivePlaygroundWeb.Recipes
  alias LivePlaygroundWeb.Comps

  embed_templates "layouts/*"
end
