defmodule LivePlaygroundWeb.RecipesLive.Upload do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Locations
  alias LivePlayground.Locations.Location

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(form: to_form(Locations.change_location(%Location{})))
      |> allow_upload(
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
      File Uploads UI
      <:subtitle>
        Creating File Upload Controls and Previews in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->

    <.form for={@form} phx-change="validate" class="space-y-6">
      <!-- Form input field -->
      <.input field={@form[:name]} placeholder="Name" />
      <!-- File upload drop zone -->
      <div
        phx-drop-target={@uploads.photos.ref}
        class="flex justify-center rounded-lg border border-dashed border-zinc-900/25 px-6 py-10"
      >
        <div class="text-center">
          <!-- Upload icon -->
          <.icon name="hero-photo" class="mx-auto h-12 w-12 text-zinc-300" />
          <!-- Upload instructions -->
          <div class="mt-4 flex text-sm leading-6 text-zinc-600">
            <!-- Custom styled label that triggers hidden file input -->
            <label for={@uploads.photos.ref} class="relative cursor-pointer rounded-md bg-white font-semibold">
              <span>Upload a file</span>
              <!-- Hidden file input - clicking label above opens file dialog -->
              <.live_file_input upload={@uploads.photos} class="sr-only" />
            </label>
            <p class="pl-1">or drag and drop</p>
          </div>
          <!-- Upload constraints display -->
          <p class="text-xs leading-5 text-zinc-600">
            {@uploads.photos.max_entries}
            {format_accept_filetypes_list(@uploads.photos.accept)} files up to {format_max_file_size_mb(@uploads.photos.max_file_size)} MB each
          </p>
        </div>
      </div>
      <!-- Global upload errors (e.g., too many files, general upload failures) -->
      <.error :for={err <- upload_errors(@uploads.photos)}>
        {Phoenix.Naming.humanize(err)}
      </.error>
      <!-- File preview grid -->
      <ul role="list" class="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 xl:grid-cols-4">
        <!-- Preview container for each selected file -->
        <li :for={entry <- @uploads.photos.entries}>
          <!-- Image preview for valid files -->
          <.live_img_preview
            :if={:not_accepted not in upload_errors(@uploads.photos, entry)}
            entry={entry}
            class="object-contain w-full h-28 sm:h-44 rounded-lg bg-zinc-200"
          />
          <!-- Fallback display for invalid files - shows filename when image preview isn't available -->
          <div
            :if={:not_accepted in upload_errors(@uploads.photos, entry)}
            class="flex items-center justify-center text-xs w-full h-28 sm:h-44 rounded-lg bg-zinc-100 text-ellipsis truncate"
          >
            {entry.client_name}
          </div>
          <!-- Upload progress and controls -->
          <div class="flex justify-between items-center space-x-2">
            <!-- Progress ring indicator -->
            <div :if={upload_errors(@uploads.photos, entry) == []} class="mt-3 flex gap-3 text-sm leading-6">
              <svg class="mt-0.5 w-5 h-5 flex-none">
                <!-- Background circle -->
                <circle class="text-gray-300" stroke-width="3" stroke="currentColor" fill="transparent" r="7.5" cx="10" cy="10" />
                <!-- Progress circle (not showing up in this demo that showcases select/drop and preview area) -->
                <circle
                  class="text-zinc-600"
                  stroke-width="3"
                  stroke-dasharray={get_circle_length(7.5)}
                  stroke-dashoffset={get_circle_length(7.5) - entry.progress / 100 * get_circle_length(7.5)}
                  stroke-linecap="round"
                  stroke="currentColor"
                  fill="transparent"
                  r="7.5"
                  cx="10"
                  cy="10"
                />
              </svg>
              <!-- Progress percentage (not showing up in this demo that showcases select/drop and preview area) -->
              <div :if={entry.progress > 0}>
                {entry.progress}%
              </div>
            </div>
            <!-- Per-file upload errors (e.g., not accepted, too large)  -->
            <.error :for={err <- upload_errors(@uploads.photos, entry)}>
              {Phoenix.Naming.humanize(err)}
            </.error>
            <!-- Cancel button to remove file -->
            <.link phx-click="cancel" phx-value-ref={entry.ref} class="mt-2">
              <.icon name="hero-trash" class="w-5 h-5 text-zinc-400 hover:text-zinc-600" />
            </.link>
          </div>
        </li>
      </ul>
    </.form>

    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.note icon="hero-information-circle">
        Please take note that in this recipe, we have constructed the Upload UI employing
        Phoenix components and Tailwind CSS. In our <.link class="underline" navigate={~p"/upload-server"}>next recipe</.link>,
        we will encapsulate the Upload UI within our own streamlined and efficient components.
      </.note>
      <.code_block filename="lib/live_playground_web/live/recipes_live/upload.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# upload" to="# endupload" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/upload.html" />
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

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  defp format_accept_filetypes_list(accept) do
    accept
    |> String.split(",")
    |> Enum.map(&String.trim_leading(&1, "."))
    |> Enum.map(&String.upcase/1)
    |> Enum.join(", ")
  end

  defp format_max_file_size_mb(size) do
    trunc(size / 1_000_000)
  end

  defp get_circle_length(radius) do
    2 * :math.pi() * radius
  end
end
