defmodule LivePlaygroundWeb.CompsLive.InputCheckbox do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  def mount(_params, _session, socket) do
    language = Languages.get_language!(228)

    form =
      language
      |> Languages.change_language()
      |> to_form()

    {:ok,
     assign(socket,
       language: language,
       form: form
     )}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Checkbox
      <:subtitle>
        How to Display Checkbox
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def input">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-change="demo" class="space-y-5">
      <div class="space-y-2">
        <.input label="Small" type="checkbox" name="sm" value={false} />
        <.input label="Large" type="checkbox" name="lg" value={true} />
      </div>
      <div class="space-y-2">
        <p><%= @language.language %></p>
        <.input label="Is Official" type="checkbox" field={@form[:isofficial]} />
      </div>
    </.form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/input_checkbox.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("demo", _, socket) do
    {:noreply, socket}
  end
end