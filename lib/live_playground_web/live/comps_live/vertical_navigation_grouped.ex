defmodule LivePlaygroundWeb.CompsLive.VerticalNavigationGrouped do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Grouped Vertical Navigation
      <:subtitle>
        How to ...
      </:subtitle>
      <:actions>...</:actions>
    </.header>
    <!-- end hiding from live code -->
    """
  end
end
