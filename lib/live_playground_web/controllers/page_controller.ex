defmodule LivePlaygroundWeb.PageController do
  use LivePlaygroundWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: {LivePlaygroundWeb.Layouts, :home})
  end

  def rules(conn, _params) do
    render(conn, :rules, layout: {LivePlaygroundWeb.Layouts, :page})
  end
end
