defmodule LivePlaygroundWeb.RecipesLive.UploadCloud do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Locations
  alias LivePlayground.Locations.Location

  @s3_bucket "eu-hosted-content"
  @s3_url "//#{@s3_bucket}.s3.eu-north-1.amazonaws.com"
  @s3_region "eu-north-1"

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
        max_file_size: 10_000_000,
        external: &presign_upload/2
      )

    {:ok, socket}
  end

  defp presign_upload(entry, socket) do
    config = %{
      region: @s3_region,
      access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
      secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY")
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, @s3_bucket,
        key: filename(entry),
        content_type: entry.client_type,
        max_file_size: socket.assigns.uploads.photos.max_file_size,
        expires_in: :timer.hours(1)
      )

    metadata = %{
      uploader: "S3",
      key: filename(entry),
      url: @s3_url,
      fields: fields
    }

    {:ok, metadata, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      File Uploads to Cloud
      <:subtitle>
        Uploading Files to Cloud Storage via LiveView
      </:subtitle>
      <:actions>
        <.code_breakdown_link />
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
        <div class="flex flex-wrap gap-4 mt-4 md:hidden">
          <a :for={photo_s3 <- location.photos_s3} href={photo_s3} target="_blank">
            <img src={photo_s3} } class="h-10 rounded" />
          </a>
        </div>
      </:col>
      <:col :let={{_id, location}} label="Photos" class="hidden md:table-cell">
        <div class="flex flex-wrap gap-4">
          <a :for={photo_s3 <- location.photos_s3} href={photo_s3} target="_blank">
            <img src={photo_s3} } class="h-10 rounded" />
          </a>
        </div>
      </:col>
      <:action :let={{_id, location}}>
        <.link :if={location.photos_s3 != []} phx-click={JS.push("remove", value: %{id: location.id})} data-confirm="Are you sure?">
          <span class="hidden md:inline">Remove Images</span>
          <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/upload_cloud.ex" />
      <.code_block filename="lib/live_playground/locations.ex" from="# uploadcloud" to="# enduploadcloud" />
      <.code_block
        filename="assets/js/app.js"
        from="// Establish Phoenix Socket and LiveView configuration"
        to="// Show progress bar on live navigation and form submits"
        elixir={false}
      />
      <.code_block filename="assets/js/uploaders/S3.js" />
      <.code_block filename="lib/live_playground/simple_s3_upload.ex" />
      <.note icon="hero-information-circle">
        <div class="ml-3 flex flex-col space-y-4">
          <p>Access to S3 is governed by a set of credentials: an access key id and a secret access key. The access key identifies
            your S3 account and the secret access key should be treated like a password. Your S3 credentials can be found on the
            Your Security Credentials section of the AWS console.</p>
          <img src="/images/s3_access.png" class="rounded xl:w-2/3" />
          <p>To ensure the success of this recipe, store an access key id and a secret access key as system environmental variables.
            As an illustration, on a Windows system:</p>
          <img src="/images/env_var.png" class="rounded xl:w-96" />
          <p>
            You'll also need to configure cross-origin resource sharing (CORS) on the bucket in order for LiveView to POST form data
            to the bucket. To do that from the S3 console, choose the name of the bucket and then choose "Permissions". Bear in mind,
            this configuration is very permissive and therefore best suited for educational purposes.
          </p>
          <img src="/images/s3_bucket_permissions.png" class="rounded xl:w-1/2" />
        </div>
      </.note>
    </div>
    <.code_breakdown_slideover filename="priv/static/html/upload_cloud.html" />
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

    photos_s3 =
      consume_uploaded_entries(socket, :photos, fn _meta, entry ->
        {:ok, Path.join(@s3_url, filename(entry))}
      end)

    params = Map.put(params, "photos_s3", photos_s3)

    Locations.update_location(selected_location, params)
    {:noreply, socket}
  end

  def handle_event("remove", %{"id" => id}, socket) do
    selected_location = Locations.get_location!(id)
    params = Map.put(%{}, "photos_s3", [])
    Locations.update_location(selected_location, params)
    {:noreply, socket}
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
end
