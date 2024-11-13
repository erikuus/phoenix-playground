defmodule LivePlaygroundWeb.CompsLive.InputTextarea do
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
       name: "Erik",
       form: form
     )}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Textarea
      <:subtitle>
        Integrating Textareas in LiveView
      </:subtitle>
      <:actions class="flex-col space-y-2 items-end">
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def input">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-change="demo" class="space-y-5">
      <.input label="Name" type="textarea" rows="3" id="name" name="name" value={@name} errors={["Oops!"]} />
      <.input label="Language" type="textarea" rows="3" field={@form[:language]} />
    </.form>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/input_textarea.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("demo", _, socket) do
    {:noreply, socket}
  end
end
