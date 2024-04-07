defmodule LivePlaygroundWeb.CompsLive.Table do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  def mount(_params, _session, socket) do
    languages = Languages.list_languages_by_countries(["EST"])
    {:ok, assign(socket, :languages, languages)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Table Basics
      <:subtitle>
        Building Basic Tables in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def table">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.table id="with-text-only" rows={@languages}>
      <:col :let={language} label="Countrycode"><%= language.countrycode %></:col>
      <:col :let={language} label="Isofficial"><%= language.isofficial %></:col>
      <:col :let={language} label="Language"><%= language.language %></:col>
      <:col :let={language} label="Percentage" class="hidden sm:table-cell"><%= language.percentage %></:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/table.ex" />
      <.code_block filename="lib/live_playground/languages.ex" from="# table" to="# endtable" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end