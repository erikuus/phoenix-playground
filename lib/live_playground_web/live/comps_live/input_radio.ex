defmodule LivePlaygroundWeb.CompsLive.InputRadio do
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
      Radio
      <:subtitle>
        Working with Radio Buttons in LiveView
      </:subtitle>
      <:actions class="flex-col space-y-2 items-end">
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def input">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-change="demo" class="space-y-5">
      <div class="space-y-2">
        <.input type="radio" name="sex" value={:male} checked={true} label="Male" />
        <.input type="radio" name="sex" value={:female} checked={false} label="Female" />
      </div>
      <div class="space-y-2">
        <p><%= @language.language %></p>
        <.input label="Yes" type="radio" field={@form[:isofficial]} value="true" checked={@language.isofficial == true} />
        <.input label="No" type="radio" field={@form[:isofficial]} value="false" checked={@language.isofficial == false} />
      </div>
    </.form>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/input_radio.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("demo", _, socket) do
    {:noreply, socket}
  end
end
