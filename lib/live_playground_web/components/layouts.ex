defmodule LivePlaygroundWeb.Layouts do
  use LivePlaygroundWeb, :html

  import LivePlaygroundWeb.MenuComponent

  embed_templates "layouts/*"
end
