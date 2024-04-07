defmodule LivePlaygroundWeb.CompsLive.UploadsPhotoPreviewArea do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      allow_upload(
        socket,
        :photos,
        accept: ~w(.png .jpg),
        max_entries: 4,
        max_file_size: 10_000_000
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Photo Preview Area
      <:subtitle>
        Previewing Uploadable Photos in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def uploads_photo_preview_area">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form phx-change="validate" class="space-y-6">
      <.uploads_upload_area uploads_name={@uploads.photos} />
      <.uploads_photo_preview_area uploads_name={@uploads.photos} />
    </form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/uploads_photo_preview_area.ex" />
      <.note icon="hero-information-circle">
        This interface is a component demonstration only. For details on implementing full upload functionality, refer to
        <.link class="underline" navigate={~p"/upload-server"}>this recipe.</.link>
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end
end
