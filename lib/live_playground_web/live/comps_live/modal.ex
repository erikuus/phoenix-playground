defmodule LivePlaygroundWeb.CompsLive.Modal do
  use LivePlaygroundWeb, :live_view

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Modal with Live Component
      <:subtitle>
        Embedding Live Components in Modals
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/core_components.ex" definition="def modal">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button_link patch={~p"/modal/image"}>
      Show modal
    </.button_link>
    <.modal :if={@live_action == :image} id="image-modal" show on_cancel={JS.navigate(~p"/modal")} width_class="max-w-5xl">
      <.live_component
        module={LivePlaygroundWeb.CompsLive.ImageComponent}
        id={:image}
        title="Image Component"
        images={["DSC02232.jpg", "DSC02234.jpg", "DSC02235.jpg"]}
        return_text="Close"
        return_to={~p"/modal"}
      />
    </.modal>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/modal.ex" />
      <.code_block filename="lib/live_playground_web/live/comps_live/image_component.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
