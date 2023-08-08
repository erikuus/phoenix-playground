defmodule LivePlaygroundWeb.ReceipesLive.Upload do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(Cities.change_city(%City{}))
      )

    socket =
      allow_upload(
        socket,
        :photos,
        accept: ~w(.png .jpeg .jpg),
        max_entries: 8,
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
        How to create file upload controls and previews in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/upload-server"}>
          See also: File Uploads to Server <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-submit="save" phx-change="validate" class="space-y-6">
      <.input field={@form[:name]} placeholder="Name" />

      <div
        phx-drop-target={@uploads.photos.ref}
        class="flex justify-center rounded-lg border border-dashed border-zinc-900/25 px-6 py-10"
      >
        <div class="text-center">
          <.icon name="hero-photo" class="mx-auto h-12 w-12 text-zinc-300" />
          <div class="mt-4 flex text-sm leading-6 text-zinc-600">
            <label for={@uploads.photos.ref} class="relative cursor-pointer rounded-md bg-white font-semibold">
              <span>Upload a file</span>
              <.live_file_input upload={@uploads.photos} class="sr-only" />
            </label>
            <p class="pl-1">or drag and drop</p>
          </div>
          <p class="text-xs leading-5 text-zinc-600">
            <%= @uploads.photos.max_entries %> PNG, JPG photos up to <%= trunc(@uploads.photos.max_file_size / 1_000_000) %> MB each
          </p>
        </div>
      </div>

      <.error :for={err <- upload_errors(@uploads.photos)}>
        <%= Phoenix.Naming.humanize(err) %>
      </.error>

      <ul role="list" class="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 xl:grid-cols-4">
        <li :for={entry <- @uploads.photos.entries}>
          <.live_img_preview
            :if={:not_accepted not in upload_errors(@uploads.photos, entry)}
            entry={entry}
            class="object-contain w-full h-28 sm:h-44 rounded-lg bg-zinc-200"
          />
          <div
            :if={:not_accepted in upload_errors(@uploads.photos, entry)}
            class="flex items-center justify-center text-xs w-full h-28 sm:h-44 rounded-lg bg-zinc-100 text-ellipsis truncate"
          >
            <%= entry.client_name %>
          </div>
          <div class="flex justify-between items-center space-x-2">
            <!-- progress ring -->
            <div :if={upload_errors(@uploads.photos, entry) == []} class="mt-3 flex gap-3 text-sm leading-6">
              <svg class="mt-0.5 w-5 h-5 flex-none">
                <circle class="text-gray-300" stroke-width="3" stroke="currentColor" fill="transparent" r="7.5" cx="10" cy="10" />
                <circle
                  class="text-zinc-600"
                  stroke-width="3"
                  stroke-dasharray={get_circumference(7.5)}
                  stroke-dashoffset={get_circumference(7.5) - entry.progress / 100 * get_circumference(7.5)}
                  stroke-linecap="round"
                  stroke="currentColor"
                  fill="transparent"
                  r="7.5"
                  cx="10"
                  cy="10"
                />
              </svg>
              <div :if={entry.progress > 0}>
                <%= entry.progress %>%
              </div>
            </div>
            <.error :for={err <- upload_errors(@uploads.photos, entry)}>
              <%= Phoenix.Naming.humanize(err) %>
            </.error>
            <.link phx-click="cancel" phx-value-ref={entry.ref} class="mt-2">
              <.icon name="hero-trash" class="w-5 h-5 text-zinc-400 hover:text-zinc-600" />
            </.link>
          </div>
        </li>
      </ul>
    </.form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/upload.ex")) %>
      <%= raw(code("lib/live_playground/cities.ex", "# upload", "# endupload")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("validate", %{"city" => params}, socket) do
    changeset =
      %City{}
      |> Cities.change_city(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  defp get_circumference(radius) do
    2 * Math.pi() * radius
  end
end
