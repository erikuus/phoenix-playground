defmodule LivePlaygroundWeb.PageController do
  use LivePlaygroundWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: {LivePlaygroundWeb.Layouts, :home})
  end
end
