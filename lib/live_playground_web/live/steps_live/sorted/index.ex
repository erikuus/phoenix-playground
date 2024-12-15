defmodule LivePlaygroundWeb.StepsLive.Sorted.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.SortedLanguages
  alias LivePlayground.SortedLanguages.Language
  alias LivePlaygroundWeb.PaginationHelpers
  alias LivePlaygroundWeb.SortingHelpers

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: SortedLanguages.subscribe()

    pagination_context = %PaginationHelpers.Context{
      stream_name: :languages,
      fetch_data_fn: fn opts -> SortedLanguages.list_languages(opts) end,
      fetch_url_fn: &get_url/1,
      default_per_page: 5
    }

    sorting_context = %SortingHelpers.Context{
      allowed_sort_fields: [:countrycode, :isofficial, :language, :percentage],
      sort_by: :countrycode,
      sort_order: :asc,
      fetch_url_fn: &get_url/1
    }

    socket =
      socket
      |> assign(:pagination_context, pagination_context)
      |> assign(:sorting_context, sorting_context)
      |> assign(:count_all, SortedLanguages.count_languages())

    options =
      %{}
      |> SortingHelpers.convert_params(socket, params)
      |> PaginationHelpers.convert_params(socket, params)

    valid_options =
      options
      |> SortingHelpers.validate_options(socket)
      |> PaginationHelpers.validate_options(socket)

    if options != valid_options do
      {:ok, push_navigate(socket, to: get_url(valid_options))}
    else
      IO.inspect(valid_options, label: "Valid options on mount")
      {:ok, PaginationHelpers.init(socket, valid_options)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)
      |> SortingHelpers.apply_options(socket.assigns.live_action, params)
      |> PaginationHelpers.apply_options(socket.assigns.live_action, params, false)

    IO.inspect(socket.assigns.options, label: "Valid options on handle params")
    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Language")
    |> assign(:language, SortedLanguages.get_language!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Language")
    |> assign(:language, %Language{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Languages")
    |> assign(:language, nil)
  end

  @impl true
  def handle_event("change-per-page", params, socket) do
    options = PaginationHelpers.update_per_page_option(socket, params)
    socket = push_patch(socket, to: get_url(options))
    {:noreply, socket}
  end

  @impl true
  def handle_event("reset-stream", %{} = params, socket) do
    socket =
      socket
      |> clear_flash()
      |> PaginationHelpers.apply_options(:index, params, true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    language = SortedLanguages.get_language!(id)

    case SortedLanguages.delete_language(language) do
      {:ok, deleted_language} ->
        {:noreply,
         socket
         |> PaginationHelpers.handle_deleted(deleted_language)
         |> put_flash(
           :info,
           get_flash_message_with_reset_link(
             "Language deleted. It will be removed from the list when you navigate away or refresh."
           )
         )}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to delete language due to an internal error.")}
    end
  end

  @impl true
  def handle_info(
        {LivePlaygroundWeb.StepsLive.Sorted.FormComponent, {:created, language}},
        socket
      ) do
    socket =
      socket
      |> PaginationHelpers.handle_created(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link(
          "Language created successfully. It has been temporarily added to the top of the list and will be sorted to its correct position on the next page load."
        )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlaygroundWeb.StepsLive.Sorted.FormComponent, {:updated, language}},
        socket
      ) do
    socket =
      socket
      |> PaginationHelpers.handle_updated(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link("Language updated successfully.")
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlayground.SortedLanguages, {:created, language}},
        socket
      ) do
    socket =
      socket
      |> PaginationHelpers.handle_created(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link(
          "A new language was added by another user. It has been temporarily added to the top of the list and will be sorted to its correct position on the next page load."
        )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlayground.SortedLanguages, {:updated, language}},
        socket
      ) do
    socket =
      socket
      |> PaginationHelpers.handle_updated(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link("A language was updated by another user.")
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlayground.SortedLanguages, {:deleted, language}},
        socket
      ) do
    socket = PaginationHelpers.handle_deleted(socket, language)

    if socket.assigns.live_action == :edit and socket.assigns.language.id == language.id do
      # Inform the user and close the modal without changing the URL
      socket =
        socket
        |> put_flash(
          :error,
          get_flash_message_with_reset_link(
            "The language you were editing was deleted by another user."
          )
        )
        |> assign(:live_action, :index)
        |> assign(:language, nil)

      {:noreply, socket}
    else
      # General deletion notification
      socket =
        socket
        |> put_flash(
          :info,
          get_flash_message_with_reset_link(
            "A language was deleted by another user. It will be removed from the list when you navigate away or refresh."
          )
        )

      {:noreply, socket}
    end
  end

  defp get_url(options, base_path \\ "/steps/sorted") do
    query_string = URI.encode_query(options)
    "#{base_path}?#{query_string}"
  end

  defp get_flash_message_with_reset_link(message) do
    link =
      link("Click here to reload and sort now",
        to: "#",
        phx_click: "reset-stream",
        class: "underline"
      )

    [message, " ", link]
  end

  defp get_row_class(language) do
    cond do
      Map.get(language, :created, false) -> "bg-green-50"
      Map.get(language, :updated, false) -> "bg-blue-50"
      Map.get(language, :deleted, false) -> "bg-zinc-50 !text-zinc-400 line-through"
      true -> ""
    end
  end

  defp format_percentage(value, precision \\ 1) do
    Number.Percentage.number_to_percentage(value, precision: precision)
  end
end
