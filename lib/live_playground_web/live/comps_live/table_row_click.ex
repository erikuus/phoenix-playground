defmodule LivePlaygroundWeb.CompsLive.TableRowClick do
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
      Table with Row Click
      <:subtitle>
        Making Table Rows Clickable in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def table">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.table id="with-row-click" rows={@languages} row_click={fn language -> JS.push("noaction", value: %{id: language.id}) end}>
      <:col :let={language} label="Countrycode"><%= language.countrycode %></:col>
      <:col :let={language} label="Isofficial"><%= language.isofficial %></:col>
      <:col :let={language} label="Language"><%= language.language %></:col>
      <:col :let={language} label="Percentage" class="hidden sm:table-cell"><%= language.percentage %></:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/table_row_click.ex" />
      <.code_block filename="lib/live_playground/languages.ex" from="# table" to="# endtable" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("noaction", %{"id" => id}, socket) do
    {:noreply, put_noaction_flash(socket, id)}
  end

  defp put_noaction_flash(socket, id) do
    put_flash(
      socket,
      :info,
      "ID=#{id}. Real actions are not supported in this demo. Please check the recipes section."
    )
  end
end
