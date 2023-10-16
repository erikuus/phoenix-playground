defmodule LivePlaygroundWeb.CompsLive.Input do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  def mount(_params, _session, socket) do
    form =
      Languages.get_language!(228)
      |> Languages.change_language()
      |> to_form()

    {:ok,
     assign(socket,
       firstname: "Erik",
       lastname: "Uus",
       age: 50,
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
      <div class="grid gap-6 grid-cols-1 sm:grid-cols-2 xl:gap-0 xl:grid-cols-4 xl:divide-x xl:divide-gray-100">
        <div class="space-y-8 xl:pr-4">
          <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
            Textbox
          </h2>
          <.input type="text" name="firstname" value={@firstname} errors={["What is this?"]} />
          <.input type="text" name="lastname" value={@lastname} label="Lastname" />
          <.input field={@form[:language]} label="Language" />
        </div>
        <div class="space-y-8 xl:px-4">
          <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
            Select
          </h2>
          <.input type="select" name="size" options={[5, 10, 20, 50, 100]} value={10} errors={["What is this?"]} />
          <.input type="select" name="age" options={age_options()} value={@age} label="Age" />
          <.input type="select" name="age" options={language_options()} value={} label="Language" prompt="Select:" />
        </div>
        <div class="space-y-8 xl:px-4">
          <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
            Checkbox
          </h2>
          <.input type="checkbox" name="sm" value={:sm} errors={["What is this?"]} />
          <.input type="checkbox" name="md" value={:md} label="Medium" />
          <.input type="checkbox" name="lg" value={:lg} checked={true} label="Large" />
          <.input type="checkbox" field={@form[:isofficial]} label="Is Official" />
        </div>
        <div class="space-y-8 xl:pl-4">
          <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
            Radio
          </h2>
        </div>
      </div>
    </.form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/input.ex" />
      <.code_block filename="lib/live_playground/languages.ex" from="# input" to="# endinput" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("demo", _, socket) do
    {:noreply, socket}
  end

  defp age_options() do
    [
      Five: 5,
      Ten: 10,
      Twenty: 20,
      Fifty: 50,
      Hundred: 100
    ]
  end

  defp language_options() do
    Languages.list_languages_by_countries(["USA", "EST"])
    |> Enum.reduce([], fn x, acc -> [{x.countrycode, x.language} | acc] end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end
end
