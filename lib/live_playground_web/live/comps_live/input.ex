defmodule LivePlaygroundWeb.CompsLive.Input do
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
       age: 50,
       language: language,
       form: form
     )}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Input
      <:subtitle>
        How to use input component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def input">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form phx-change="demo">
      <div class="grid gap-6 grid-cols-1 sm:grid-cols-2 xl:gap-0 xl:grid-cols-5 xl:divide-x xl:divide-gray-100">
        <div class="space-y-5 xl:pr-4 mb-6">
          <h2 class="truncate font-medium leading-7 text-zinc-500">
            Textbox
          </h2>
          <.input label="Name" name="name" value={@name} errors={["Who is he?"]} />
          <.input label="Country" field={@form[:countrycode]} />
        </div>
        <div class="space-y-5 xl:px-4 mb-6">
          <h2 class="truncate font-medium leading-7 text-zinc-500">
            Select
          </h2>
          <.input
            label="Age"
            type="select"
            name="size"
            options={[Five: 5, Ten: 10, Twenty: 20, Fifty: 50, Ninety: 90]}
            value={@age}
            errors={["What is this?"]}
          />
          <.input label="Language" type="select" field={@form[:id]} options={language_options()} prompt="Select:" />
        </div>
        <div class="space-y-5 xl:px-4 mb-6 sm:row-span-2 xl:row-span-0">
          <h2 class="truncate font-medium leading-7 text-zinc-500">
            Textarea
          </h2>
          <.input label="Description" type="textarea" name="desc" value={placeholder_sentences(1, true)} errors={["What is this?"]} />
          <.input label="Percentage" type="textarea" field={@form[:percentage]} rows="5" />
        </div>
        <div class="space-y-5 xl:px-4 mb-6 sm:mb-0">
          <h2 class="truncate font-medium leading-7 text-zinc-500">
            Checkbox
          </h2>
          <.input label="Small" type="checkbox" name="sm" value={false} errors={["What is this?"]} />
          <.input label="Large" type="checkbox" name="lg" value={true} />
          <.input label="Is Official" type="checkbox" field={@form[:isofficial]} />
        </div>
        <div class="space-y-5 xl:pl-4">
          <h2 class="truncate font-medium leading-7 text-zinc-500">
            Radio
          </h2>
          <div>
            <.input type="radio" name="sex" value={:male} checked={true} label="Male" />
            <.input type="radio" name="sex" value={:female} checked={false} label="Female" />
          </div>
          <div>
            <.input label="Yes" type="radio" field={@form[:isofficial]} value="true" checked={@language.isofficial == true} />
            <.input label="No" type="radio" field={@form[:isofficial]} value="false" checked={@language.isofficial == false} />
          </div>
        </div>
      </div>
    </.form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/input.ex" />
      <.code_block filename="lib/live_playground/languages.ex" from="# input" to="# endinput" />
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

  defp language_options() do
    Languages.list_languages_by_countries(["USA", "EST"])
    |> Enum.reduce([], fn x, acc -> [{x.countrycode, {x.language, x.id}} | acc] end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end
end
