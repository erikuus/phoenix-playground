defmodule LivePlaygroundWeb.RecipesLive.UploadServer do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Locations
  alias LivePlayground.Locations.Location

  @uploads "uploads"

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
        accept: ~w(.png .jpg .jpeg),
        max_entries: 8,
        max_file_size: 10_000_000
      )

    {:ok, socket}
  end

  def terminate(_reason, _socket) do
    Locations.unsubscribe()
    :ok
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      File Uploads to Server
      <:subtitle>
        Uploading Files to a Server in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-submit="save" phx-change="validate" class="space-y-6">
      <.input type="select" field={@form[:id]} label="Location" options={@options} />
      <.uploads_upload_area uploads_name={@uploads.photos} />
      <.error :for={err <- upload_errors(@uploads.photos)}>
        {Phoenix.Naming.humanize(err)}
      </.error>
      <.uploads_photo_preview_area uploads_name={@uploads.photos} />
      <.button :if={Enum.count(@uploads.photos.entries) > 0} phx-disable-with="Uploading...">
        Upload
      </.button>
    </.form>

    <div id="locations" phx-update="stream" class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4 mt-8">
      <div
        :for={{dom_id, location} <- @streams.locations}
        id={dom_id}
        class="rounded-lg bg-gray-50 border border-gray-200 text-xs xl:text-sm"
      >
        <div class="flex justify-between items-center px-6 py-3 text-gray-500">
          <h3 class="font-medium text-sm">{location.name}</h3>
          <.link
            :if={location.photos != []}
            phx-click={JS.push("remove", value: %{id: location.id})}
            data-confirm="Are you sure to remove photos?"
          >
            <.icon name="hero-trash" class="w-4 h-4" />
          </.link>
        </div>
        <div class="bg-white p-6 rounded-b-lg">
          <div :if={location.photos != []} class="grid grid-cols-4 gap-1">
            <a :for={photo <- location.photos} href={static_path(@socket, "/uploads/#{photo}")} target="_blank">
              <img src={static_path(@socket, "/uploads/#{photo}")} class="w-full h-12 object-cover rounded" />
            </a>
          </div>
          <div :if={location.photos == []} class="text-gray-400 text-xs text-center py-4">
            No photos uploaded
          </div>
        </div>
      </div>
    </div>

    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/upload_server.ex" />
      <.code_block filename="lib/live_playground_web/endpoint.ex" from="# uploadserver" to="# enduploadserver" />
      <.code_block filename="lib/live_playground/locations.ex" from="# uploadserver" to="# enduploadserver" />
      <.code_block filename="lib/live_playground/locations/location.ex" from="# uploadserver" to="# enduploadserver" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/upload_server.html" />
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
    id = to_integer(params["id"])
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

    update_location_photos(socket, selected_location, params, old_photos)
  end

  def handle_event("remove", %{"id" => id}, socket) do
    id = to_integer(id)
    selected_location = Locations.get_location!(id)
    photos = selected_location.photos
    params = %{"photos" => []}

    update_location_photos(socket, selected_location, params, photos)
  end

  def handle_info({LivePlayground.Locations, {:update_location, location}}, socket) do
    {:noreply, stream_insert(socket, :locations, location)}
  end

  defp update_location_photos(socket, location, params, old_photos) do
    case Locations.update_location(location, params) do
      {:ok, _location} ->
        remove_photos(old_photos)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp remove_photos(photos) do
    for photo <- photos do
      photo_dest = Path.join([@uploads, photo])
      File.rm!(photo_dest)
    end
  end

  defp filename(entry) do
    base = Path.basename(entry.client_name)
    "#{entry.uuid}-#{base}"
  end

  defp to_integer(value) when is_integer(value), do: value

  defp to_integer(value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} -> i
      _ -> 0
    end
  end
end
