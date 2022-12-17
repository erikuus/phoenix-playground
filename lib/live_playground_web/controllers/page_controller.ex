defmodule LivePlaygroundWeb.PageController do
  use LivePlaygroundWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      title: gettext("Welcome to %{name}!", name: "Phoenix"),
      description: "Peace of mind from prototype to production"
    )
  end
end
