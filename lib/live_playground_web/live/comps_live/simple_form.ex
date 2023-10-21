defmodule LivePlaygroundWeb.CompsLive.SimpleForm do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    form =
      %City{}
      |> Cities.change_city()
      |> to_form()

    {:ok, assign(socket, :form, form)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Simple Form
      <:subtitle>
        How to use Simple Form component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def simple_form(">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <.flash kind={:info} flash={@flash} title="Notice:" />
    <!-- end hiding from live code -->
    <.simple_form for={@form} phx-change="validate" phx-submit="save">
      <.input field={@form[:name]} label="Name" />
      <.input field={@form[:district]} label="District" />
      <.input field={@form[:population]} label="Population" />
      <:actions>
        <.button>Save</.button>
      </:actions>
    </.simple_form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/simple_form.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("validate", %{"city" => params}, socket) do
    form =
      %City{}
      |> Cities.change_city(params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", %{"city" => _params}, socket) do
    {:noreply,
     put_flash(
       socket,
       :info,
       "Save functionality not supported in this demo. Please check the recipes section."
     )}
  end
end
