defmodule LivePlaygroundWeb.CompsLive.InputSelect do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  def mount(_params, _session, socket) do
    language = Languages.get_language!(228)
    languages = Languages.list_languages_by_countries(["USA", "EST"])

    form =
      language
      |> Languages.change_language()
      |> to_form()

    {:ok,
     assign(socket,
       age: 50,
       form: form,
       languages: languages
     )}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Select
      <:subtitle>
        Creating Select Dropdowns in LiveView
      </:subtitle>
      <:actions class="flex-col space-y-2 items-end">
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def input">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-change="demo" class="space-y-5">
      <.input
        label="Age"
        type="select"
        id="age1"
        name="age1"
        options={[Five: 5, Ten: 10, Twenty: 20, Fifty: 50, Ninety: 90]}
        value={@age}
        errors={["Oops!"]}
      />
      <.input
        label="Age By Group"
        type="select"
        id="age2"
        name="age2"
        options={[Child: [Five: 5, Ten: 10], Adult: [Twenty: 50, Fifty: 50, Ninety: 90]]}
        value={@age}
        errors={["Oops!"]}
      />
      <.input label="Language" type="select" field={@form[:id]} options={options(@languages)} prompt="" />
      <.input
        label="Language By Country"
        id="language2"
        type="select"
        field={@form[:id]}
        options={grouped_options(@languages)}
        prompt=""
      />
    </.form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/input_select.ex" />
      <.code_block filename="lib/live_playground/languages.ex" from="# input" to="# endinput" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("demo", _, socket) do
    {:noreply, socket}
  end

  defp options(languages) do
    languages |> Enum.map(&{&1.language, &1.id})
  end

  # Formats language options for a grouped select input, organized by country.
  # The expected format for the grouped select input is:
  # %{"CountryCode" => [{language_name, language_id}, ...], ...}
  # where "CountryCode" is a placeholder for actual country codes like "USA" or "EST".
  defp grouped_options(languages) do
    languages |> Enum.group_by(& &1.countrycode, &{&1.language, &1.id})
  end
end
