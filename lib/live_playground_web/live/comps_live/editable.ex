defmodule LivePlaygroundWeb.CompsLive.Editable do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  def mount(_params, _session, socket) do
    language = Languages.get_language!(228)

    socket =
      socket
      |> assign(:language, language)
      |> reset_edit_form()

    {:ok, socket}
  end

  defp reset_edit_form(socket) do
    assign(socket, edit_field: nil, form: nil)
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Editable
      <:subtitle>
        Utilizing Editable Fields in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def editable">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.list class="mt-0 xl:mr-96">
      <:item title="Countrycode">{@language.countrycode}</:item>
      <:item title="Isofficial">{@language.isofficial}</:item>
      <:item title="Language">
        <.editable id="language" save_event="nosave" form={@form} edit={@edit_field == "language"}>
          {@language.language}
          <:input_block>
            <.input field={@form[:language]} type="text" class="flex-auto md:-ml-3" />
          </:input_block>
        </.editable>
      </:item>
      <:item title="Percentage">
        <.editable
          save_event="nosave"
          edit_event="edit"
          cancel_event="cancel"
          id="percentage"
          form={@form}
          edit={@edit_field == "percentage"}
        >
          {@language.percentage}
          <:input_block>
            <.input field={@form[:percentage]} type="text" title="Percentage" class="flex-auto md:-ml-3" />
          </:input_block>
        </.editable>
      </:item>
    </.list>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/editable.ex" />
      <.code_block filename="lib/live_playground/languages.ex" from="# list" to="# endlist" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("nosave", %{"language" => params}, socket) do
    # Example of handling save:
    # case Languages.update_language(socket.assigns.language, params) do
    #   {:ok, _language} ->
    #     {:noreply, reset_edit_form(socket)}
    #   {:error, changeset} ->
    #     {:noreply, assign(socket, :form, to_form(changeset))}
    # end
    socket =
      socket
      |> reset_edit_form()
      |> put_flash(
        :info,
        "PARAMS=#{inspect(params)}. Save functionality not supported in this demo."
      )

    {:noreply, socket}
  end

  def handle_event("edit", %{"field" => field}, socket) do
    form =
      socket.assigns.language
      |> Languages.change_language()
      |> to_form()

    socket =
      assign(socket,
        edit_field: field,
        form: form
      )

    {:noreply, socket}
  end

  def handle_event("cancel", _, socket) do
    socket =
      assign(socket,
        edit_field: nil,
        form: nil
      )

    {:noreply, socket}
  end
end
