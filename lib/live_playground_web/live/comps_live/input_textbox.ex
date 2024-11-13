defmodule LivePlaygroundWeb.CompsLive.InputTextbox do
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
      Textbox
      <:subtitle>
        Utilizing Textboxes in LiveView
      </:subtitle>
      <:actions class="flex-col space-y-2 items-end">
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def input">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-change="demo" class="space-y-5">
      <.input label="Name" id="name" name="name" value={@name} errors={["Oops!"]} />
      <.input label="Country" field={@form[:countrycode]} />
    </.form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/input_textbox.ex" />
      <.note icon="hero-information-circle">
        Examine <.link class="underline" navigate={~p"/tabular-insert"}>this recipe</.link>
        to understand how to use <span class="font-mono">multiple={true}</span>
        when configuring input for tabular insert.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("demo", _, socket) do
    {:noreply, socket}
  end
end
