defmodule LivePlaygroundWeb.CompsLive.SimpleList do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Simple List
      <:subtitle>
       How to Display Simple List
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def simple_list">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.simple_list>
      <:item :for={item <- ["New York", "Los Angeles", "Chicago", "Houston"]}><%= item %></:item>
    </.simple_list>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/simple_list.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
