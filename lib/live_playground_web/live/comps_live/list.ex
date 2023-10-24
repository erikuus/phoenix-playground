defmodule LivePlaygroundWeb.CompsLive.List do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :language, Languages.get_language!(228))}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      List
      <:subtitle>
        How to use List component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def list">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.list class="mt-0">
      <:item title="Countrycode"><%= @language.countrycode %></:item>
      <:item title="Isofficial"><%= @language.isofficial %></:item>
      <:item title="Language"><%= @language.language %></:item>
      <:item title="Percentage"><%= @language.percentage %></:item>
    </.list>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/list.ex" />
      <.code_block filename="lib/live_playground/languages.ex" from="# list" to="# endlist" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
