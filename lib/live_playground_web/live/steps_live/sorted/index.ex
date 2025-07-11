defmodule LivePlaygroundWeb.StepsLive.Sorted.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.SortedLanguages
  alias LivePlayground.SortedLanguages.Language
  alias LivePlaygroundWeb.PaginationHelpers
  alias LivePlaygroundWeb.PaginationHelpers.Context, as: PaginationContext
  alias LivePlaygroundWeb.SortingHelpers
  alias LivePlaygroundWeb.SortingHelpers.Context, as: SortingContext

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: SortedLanguages.subscribe()

    pagination_context = %PaginationContext{
      per_page_options: [5, 10, 20, 50, 100],
      default_per_page: 5
    }

    sorting_context = %SortingContext{
      allowed_sort_fields: [:countrycode, :isofficial, :language, :percentage],
      sort_by: :countrycode,
      sort_order: :asc
    }

    options =
      %{}
      |> PaginationHelpers.convert_params(params)
      |> SortingHelpers.convert_params(params)

    count_all = SortedLanguages.count_languages()

    valid_options =
      options
      |> PaginationHelpers.validate_options(count_all, pagination_context)
      |> SortingHelpers.validate_options(sorting_context)

    if options != valid_options do
      {:ok, push_navigate(socket, to: get_url(valid_options))}
    else
      {:pagination_initialized, pagination_assigns} =
        PaginationHelpers.init_pagination(valid_options, count_all, pagination_context)

      {:sorting_initialized, sorting_assigns} =
        SortingHelpers.init_sorting(sorting_context)

      languages = SortedLanguages.list_languages(valid_options)

      socket =
        socket
        |> assign(:options, valid_options)
        |> assign(pagination_assigns)
        |> assign(sorting_assigns)
        |> assign(:visible_ids, Enum.map(languages, & &1.id))
        |> stream(:languages, languages)

      {:ok, socket}
    end
  end

  @impl true
  def terminate(_reason, _socket) do
    SortedLanguages.unsubscribe()
    :ok
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Languages")
    |> assign(:language, nil)
    |> apply_options(params, false)
  end

  defp apply_options(socket, params, force_reset) do
    # Resolve sorting changes, capturing whether sorting needs to trigger a stream reset.
    options = socket.assigns.options
    sorting_context = socket.assigns.sorting_context

    {sorting_requires_reset, valid_sorting_options} =
      case SortingHelpers.resolve_sorting_changes(options, params, sorting_context, force_reset) do
        {:reset_stream, valid_options} -> {true, valid_options}
        {:noreset_stream, valid_options} -> {false, valid_options}
      end

    # Combine the forced reset flag with the reset flag required by sorting.
    combined_force_reset = sorting_requires_reset or force_reset

    # Now resolve pagination changes using the updated options.
    count_all = socket.assigns.count_all
    pagination_context = socket.assigns.pagination_context

    case PaginationHelpers.resolve_pagination_changes(
           valid_sorting_options,
           params,
           count_all,
           pagination_context,
           combined_force_reset
         ) do
      {:reset_stream, valid_options, page_changed, new_assigns} ->
        languages = SortedLanguages.list_languages(valid_options)

        socket =
          socket
          |> assign(:options, valid_options)
          |> assign(new_assigns)
          |> assign(:visible_ids, Enum.map(languages, & &1.id))
          |> stream(:languages, languages, reset: true)

        if page_changed do
          push_patch(socket, to: get_url(valid_options))
        else
          socket
        end

      {:noreset_stream, valid_options} ->
        assign(socket, :options, valid_options)
    end
  end

  @impl true
  def handle_event("change-per-page", params, socket) do
    options = socket.assigns.options
    context = socket.assigns.pagination_context
    new_options = PaginationHelpers.update_per_page_option(options, params, context)
    socket = push_patch(socket, to: get_url(new_options))
    {:noreply, socket}
  end

  @impl true
  def handle_event("reset-stream", %{} = params, socket) do
    socket =
      socket
      |> clear_flash()
      |> apply_options(params, true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    language = SortedLanguages.get_language!(id)

    case SortedLanguages.delete_language(language) do
      {:ok, deleted_language} ->
        {:processed_deleted, new_assigns, marked_language} =
          PaginationHelpers.process_deleted(socket.assigns, deleted_language)

        {:noreply,
         socket
         |> assign(new_assigns)
         |> stream_insert(:languages, marked_language)
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
    {:processed_created, new_assigns, marked_language} =
      PaginationHelpers.process_created(socket.assigns, language)

    socket =
      socket
      |> assign(new_assigns)
      |> stream_insert(:languages, marked_language, at: 0)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link(
          "Language created successfully. It has been temporarily added to the top of the list
          and will be sorted to its correct position on the next page load."
        )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlaygroundWeb.StepsLive.Sorted.FormComponent, {:updated, language}},
        socket
      ) do
    {:processed_updated, marked_language} =
      PaginationHelpers.process_updated(language)

    socket =
      socket
      |> stream_insert(:languages, marked_language)
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
    {:processed_created, new_assigns, marked_language} =
      PaginationHelpers.process_created(socket.assigns, language)

    socket =
      socket
      |> assign(new_assigns)
      |> stream_insert(:languages, marked_language, at: 0)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link(
          "A new language was added by another user. It has been temporarily added to the top of the list
          and will be sorted to its correct position on the next page load."
        )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlayground.SortedLanguages, {:updated, language}},
        socket
      ) do
    if language.id in socket.assigns.visible_ids do
      {:processed_updated, marked_language} =
        PaginationHelpers.process_updated(language)

      socket =
        socket
        |> stream_insert(:languages, marked_language)
        |> put_flash(
          :info,
          get_flash_message_with_reset_link("A language was updated by another user.")
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(
        {LivePlayground.SortedLanguages, {:deleted, language}},
        socket
      ) do
    if language.id in socket.assigns.visible_ids do
      {:processed_deleted, new_assigns, marked_language} =
        PaginationHelpers.process_deleted(socket.assigns, language)

      socket =
        socket
        |> assign(new_assigns)
        |> stream_insert(:languages, marked_language)

      socket =
        if socket.assigns.live_action == :edit and socket.assigns.language.id == language.id do
          # Inform the user and close the modal without changing the URL
          socket
          |> assign(:live_action, :index)
          |> assign(:language, nil)
          |> put_flash(
            :error,
            get_flash_message_with_reset_link(
              "The language you were editing was deleted by another user."
            )
          )
        else
          # General deletion notification
          socket
          |> put_flash(
            :info,
            get_flash_message_with_reset_link(
              "A language was deleted by another user. It will be removed from the list when you navigate away or refresh."
            )
          )
        end

      {:noreply, socket}
    else
      {:noreply, update(socket, :count_all, &(&1 - 1))}
    end
  end

  defp sort_link(label, col, options, context) do
    assigns = SortingHelpers.get_sort_link_assigns(label, col, options, context)

    ~H"""
    <.link patch={get_url(assigns.options)} class="flex gap-x-1">
      <span>{@label}</span>
      <span>{@indicator}</span>
    </.link>
    """
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
