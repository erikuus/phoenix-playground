defmodule LivePlaygroundWeb.ReceipesLive.UploadServer do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Locations
  alias LivePlayground.Locations.Location

  @uploads Path.join(["priv", "static", "uploads"])

  def mount(_params, _session, socket) do
    if connected?(socket), do: Locations.subscribe()

    locations = Locations.list_est_location()
    options = Enum.map(locations, fn location -> {location.name, location.id} end)

    socket =
      socket
      |> assign_form(Locations.change_location(%Location{}))
      |> assign(:options, options)
      |> stream(:locations, locations)
      |> allow_upload(
        :photos,
        accept: ~w(.png .jpg),
        max_entries: 8,
        max_file_size: 10_000_000
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      File Uploads to Server
      <:subtitle>
        How to upload files to a server in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/upload-cloud"}>
          See also: File Uploads to Cloud <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-submit="save" phx-change="validate" class="space-y-6">
      <.input type="select" field={@form[:id]} label="Location" options={@options} />
      <.uploads_upload_area uploads_name={@uploads.photos} />
      <.error :for={err <- upload_errors(@uploads.photos)}>
        <%= Phoenix.Naming.humanize(err) %>
      </.error>
      <.uploads_photo_preview_area uploads_name={@uploads.photos} />
      <.button :if={Enum.count(@uploads.photos.entries) > 0} phx-disable-with="Uploading...">
        Upload
      </.button>
    </.form>
    <.table id="locations" rows={@streams.locations}>
      <:col :let={{_id, location}} label="Name">
        <%= location.name %>
      </:col>
      <:col :let={{_id, location}} label="Photos">
        <div class="flex flex-wrap gap-4">
          <a :for={photo <- location.photos} href={static_path(@socket, "/uploads/#{photo}")} target="_blank">
            <img src={static_path(@socket, "/uploads/#{photo}")} class="h-10 rounded" />
          </a>
        </div>
      </:col>
      <:action :let={{_id, location}}>
        <.link phx-click={JS.push("remove", value: %{id: location.id})} data-confirm="Are you sure?">
          <span class="hidden md:inline">Remove</span>
          <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/upload_server.ex")) %>
      <%= raw(code("lib/live_playground/locations.ex", "# uploadserver", "# enduploadserver")) %>
      <%= raw(code("lib/live_playground_web.ex", "# uploadserver", "# enduploadserver")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  def handle_event("validate", %{"location" => params}, socket) do
    changeset =
      %Location{}
      |> Locations.change_location(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"location" => params}, socket) do
    id = params["id"] |> String.to_integer()
    selected_location = Locations.get_location!(id)

    photos =
      consume_uploaded_entries(socket, :photos, fn meta, entry ->
        photo = "#{entry.uuid}-#{entry.client_name}"
        dest = Path.join([@uploads, photo])
        File.cp!(meta.path, dest)

        {:ok, photo}
      end)

    params = Map.put(params, "photos", photos)

    Locations.update_location(selected_location, params)
    {:noreply, socket}
  end

  def handle_event("remove", %{"id" => id}, socket) do
    selected_location = Locations.get_location!(id)
    params = Map.put(%{}, "photos", [])
    Locations.update_location(selected_location, params)
    {:noreply, socket}
  end

  def handle_info({:update_location, location}, socket) do
    {:noreply, stream_insert(socket, :locations, location)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
