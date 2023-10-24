defmodule LivePlaygroundWeb.CompsLive.Table do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  def mount(_params, _session, socket) do
    languages = Languages.list_languages_by_countries(["EST"])

    socket =
      socket
      |> assign(:languages, languages)
      |> stream(:languages, languages)

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply, put_noaction_flash(socket, id)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Table
      <:subtitle>
        How to use Table component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def table">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="grid gap-10 grid-cols-1 xl:grid-cols-2">
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With text only
        </h2>
        <.table id="with-text-only" rows={@languages}>
          <:col :let={language} label="Countrycode"><%= language.countrycode %></:col>
          <:col :let={language} label="Isofficial"><%= language.isofficial %></:col>
          <:col :let={language} label="Language"><%= language.language %></:col>
          <:col :let={language} label="Percentage" class="hidden sm:table-cell"><%= language.percentage %></:col>
        </.table>
      </div>
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With actions
        </h2>
        <.table id="with-actions" rows={@languages}>
          <:col :let={language} label="Countrycode"><%= language.countrycode %></:col>
          <:col :let={language} label="Isofficial"><%= language.isofficial %></:col>
          <:col :let={language} label="Language"><%= language.language %></:col>
          <:col :let={language} label="Percentage" class="hidden sm:table-cell"><%= language.percentage %></:col>
          <:action :let={language}>
            <.link phx-click="noaction" phx-value-id={language.id}>
              <span class="hidden sm:inline">Edit</span>
              <.icon name="hero-pencil-square-mini" class="sm:hidden h-6 w-6" />
            </.link>
          </:action>
          <:action :let={language}>
            <.link phx-click="noaction" phx-value-id={language.id} data-confirm="Are you sure?">
              <span class="hidden sm:inline">Delete</span>
              <.icon name="hero-trash-mini" class="sm:hidden" />
            </.link>
          </:action>
        </.table>
      </div>
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With row click
        </h2>
        <.table id="with-row-click" rows={@languages} row_click={fn language -> JS.push("noaction", value: %{id: language.id}) end}>
          <:col :let={language} label="Countrycode"><%= language.countrycode %></:col>
          <:col :let={language} label="Isofficial"><%= language.isofficial %></:col>
          <:col :let={language} label="Language"><%= language.language %></:col>
          <:col :let={language} label="Percentage" class="hidden sm:table-cell"><%= language.percentage %></:col>
        </.table>
      </div>
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With stream, actions and row click
        </h2>
        <.table
          id="with-stream"
          rows={@streams.languages}
          row_click={fn {_id, language} -> JS.patch(~p"/table?#{[id: language]}") end}
        >
          <:col :let={{_id, language}} label="Countrycode"><%= language.countrycode %></:col>
          <:col :let={{_id, language}} label="Isofficial"><%= language.isofficial %></:col>
          <:col :let={{_id, language}} label="Language"><%= language.language %></:col>
          <:col :let={{_id, language}} label="Percentage" class="hidden sm:table-cell"><%= language.percentage %></:col>
          <:action :let={{_id, language}}>
            <.link patch={~p"/table?#{[id: language]}"}>
              <span class="hidden sm:inline">Edit</span>
              <.icon name="hero-pencil-square-mini" class="sm:hidden h-6 w-6" />
            </.link>
          </:action>
          <:action :let={{id, language}}>
            <.link phx-click={JS.push("noaction", value: %{id: language.id}) |> hide("##{id}")} data-confirm="Are you sure?">
              <span class="hidden sm:inline">Delete</span>
              <.icon name="hero-trash-mini" class="sm:hidden" />
            </.link>
          </:action>
        </.table>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/table.ex" />
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
