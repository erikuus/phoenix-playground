defmodule LivePlaygroundWeb.CompsLive.SimpleForm do
  use LivePlaygroundWeb, :live_view

  import Phoenix.HTML

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
        Streamlining Web Forms with Simple Form in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def simple_form">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <.flash kind={:info} flash={@flash} title="Notice:" />
    <!-- end hiding from live code -->
    <.simple_form for={@form} phx-change="validate" phx-submit="nosave">
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
      <.note icon="hero-information-circle">
        <%= html_escape("
          The <.simple_form> component enhances the <.form> component by automatically wrapping form fields within a <div class=\"space-y-8 bg-white mt-10\">
          for optimal spacing and styling, and encapsulating action buttons in a <div class=\"mt-2 flex items-center justify-between gap-6\">. This is done by
          calling the <.form> component internally, thereby streamlining the presentation and organization of forms with minimal manual HTML structuring.
        ") %>
      </.note>
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

  def handle_event("nosave", %{"city" => params}, socket) do
    {:noreply,
     put_flash(
       socket,
       :info,
       "PARAMS=#{inspect(params)}. Save functionality not supported in this demo. Please check the recipes section."
     )}
  end
end
