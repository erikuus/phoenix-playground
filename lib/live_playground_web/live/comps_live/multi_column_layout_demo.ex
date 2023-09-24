defmodule LivePlaygroundWeb.CompsLive.MultiColumnLayoutDemo do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {LivePlaygroundWeb.Layouts, :demo}}
  end

  def render(assigns) do
    ~H"""
    Inner Content
    """
  end
end
