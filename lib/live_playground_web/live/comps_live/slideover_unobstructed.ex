defmodule LivePlaygroundWeb.CompsLive.SlideoverUnobstructed do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Slideover Unobstructed
      <:subtitle>
        Incorporating Slideover Without Blocking Main Content
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def slideover">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link phx-click={show_slideover(%JS{}, "as-sidepanel", true)}>
      Show slideover
    </.button_link>
    <.slideover id="as-sidepanel" enable_main_content={true}>
      <:title>With subtitle</:title>
      <div class="space-y-6 mr-2">
        <%= placeholder_paragraphs(10) %>
      </div>
    </.slideover>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/slideover_unobstructed.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
