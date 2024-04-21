defmodule LivePlaygroundWeb.RecipesLive.UploadServer do
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
        Uploading Files to a Server in LiveView
      </:subtitle>
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
      <.code_block filename="lib/live_playground_web/live/recipes_live/upload_server.ex" />
      <.code_block filename="lib/live_playground/locations.ex" from="# uploadserver" to="# enduploadserver" />
      <.code_block filename="lib/live_playground_web.ex" from="# uploadserver" to="# enduploadserver" />
      <.code_block
        filename="config/dev.exs"
        from="# Watch static and templates for browser reloading."
        to="# Enable dev routes for dashboard and mailbox"
      />
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
    old_photos = selected_location.photos

    new_photos =
      consume_uploaded_entries(socket, :photos, fn meta, entry ->
        photo = filename(entry)
        dest = Path.join([@uploads, photo])
        File.cp!(meta.path, dest)

        {:ok, photo}
      end)

    params = Map.put(params, "photos", new_photos)

    case Locations.update_location(selected_location, params) do
      {:ok, _location} ->
        remove_photos(old_photos)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("remove", %{"id" => id}, socket) do
    selected_location = Locations.get_location!(id)
    photos = selected_location.photos
    params = Map.put(%{}, "photos", [])

    case Locations.update_location(selected_location, params) do
      {:ok, _location} ->
        remove_photos(photos)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_info({:update_location, location}, socket) do
    {:noreply, stream_insert(socket, :locations, location)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp filename(entry) do
    "#{entry.uuid}-#{entry.client_name}"
  end

  defp remove_photos(photos) do
    for photo <- photos do
      photo_dest = Path.join([@uploads, photo])
      File.rm!(photo_dest)
    end
  end
end
