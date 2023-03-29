defmodule LivePlaygroundWeb.Layouts do
  use LivePlaygroundWeb, :html

  alias LivePlaygroundWeb.MainMenu
  alias LivePlaygroundWeb.RecipesMenu

  embed_templates "layouts/*"
end
