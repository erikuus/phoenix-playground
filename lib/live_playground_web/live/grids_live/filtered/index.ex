defmodule LivePlaygroundWeb.GridsLive.Filtered.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.FilteredLanguages
  alias LivePlayground.FilteredLanguages.Language
  alias LivePlaygroundWeb.PaginationHelpers
  alias LivePlaygroundWeb.PaginationHelpers.Context, as: PaginationContext
  alias LivePlaygroundWeb.SortingHelpers
  alias LivePlaygroundWeb.SortingHelpers.Context, as: SortingContext
  alias LivePlaygroundWeb.FilteringHelpers
  alias LivePlaygroundWeb.FilteringHelpers.Context, as: FilteringContext
  alias LivePlaygroundWeb.FilteringHelpers.FilterField

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: FilteredLanguages.subscribe()

    pagination_context = %PaginationContext{
      per_page_options: [5, 10, 20, 50, 100],
      default_per_page: 5
    }

    sorting_context = %SortingContext{
      allowed_sort_fields: [:countrycode, :isofficial, :language, :percentage],
      sort_by: :countrycode,
      sort_order: :asc
    }

    filtering_context = %FilteringContext{
      fields: %{
        countrycode: %FilterField{
          type: :string,
          default: ""
        },
        language: %FilterField{
          type: :string,
          default: ""
        },
        isofficial: %FilterField{
          type: :boolean,
          default: "",
          validate: {:in, [true, false, ""]}
        },
        percentage_min: %FilterField{
          type: :integer,
          default: 50,
          validate: {:custom, &validate_percentage/1}
        },
        percentage_max: %FilterField{
          type: :integer,
          default: "",
          validate: {:custom, &validate_percentage/1}
        }
      }
    }

    options =
      %{}
      |> FilteringHelpers.convert_params(params, filtering_context)
      |> SortingHelpers.convert_params(params)
      |> PaginationHelpers.convert_params(params)

    valid_filter_options =
      options
      |> FilteringHelpers.apply_defaults(filtering_context)
      |> FilteringHelpers.validate_options(filtering_context)

    count_all = FilteredLanguages.count_languages(valid_filter_options)

    valid_options =
      valid_filter_options
      |> SortingHelpers.validate_options(sorting_context)
      |> PaginationHelpers.validate_options(count_all, pagination_context)

    if options != valid_options do
      {:ok, push_navigate(socket, to: get_url(valid_options))}
    else
      {:pagination_initialized, pagination_assigns} =
        PaginationHelpers.init_pagination(valid_options, count_all, pagination_context)

      {:sorting_initialized, sorting_assigns} =
        SortingHelpers.init_sorting(sorting_context)

      {:filtering_initialized, filtering_assigns} =
        FilteringHelpers.init_filtering(filtering_context)

      languages = FilteredLanguages.list_languages(valid_options)

      socket =
        socket
        |> assign(:options, valid_options)
        |> assign(pagination_assigns)
        |> assign(sorting_assigns)
        |> assign(filtering_assigns)
        |> assign(:visible_ids, Enum.map(languages, & &1.id))
        |> stream(:languages, languages)

      {:ok, socket}
    end
  end

  # Add validation function
  defp validate_percentage(value) when is_integer(value) and value >= 0 and value <= 100,
    do: {:ok, value}

  defp validate_percentage(_), do: :error

  @impl true
  def terminate(_reason, _socket) do
    FilteredLanguages.unsubscribe()
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Language")
    |> assign(:language, FilteredLanguages.get_language!(id))
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
    options = socket.assigns.options
    sorting_context = socket.assigns.sorting_context
    filtering_context = socket.assigns.filtering_context
    count_all = socket.assigns.count_all

    # First handle filtering changes
    {filtering_requires_reset, valid_filtering_options} =
      case FilteringHelpers.resolve_filtering_changes(
             options,
             params,
             filtering_context,
             force_reset
           ) do
        {:reset_stream, valid_options} -> {true, valid_options}
        {:noreset_stream, valid_options} -> {false, valid_options}
      end

    # Recalculate count if filters changed - pagination needs accurate count
    count_all =
      if filtering_requires_reset do
        FilteredLanguages.count_languages(valid_filtering_options)
      else
        count_all
      end

    # Then handle sorting with combined reset flag
    combined_force_reset = filtering_requires_reset or force_reset

    {sorting_requires_reset, valid_sorting_options} =
      case SortingHelpers.resolve_sorting_changes(
             valid_filtering_options,
             params,
             sorting_context,
             combined_force_reset
           ) do
        {:reset_stream, valid_options} -> {true, valid_options}
        {:noreset_stream, valid_options} -> {false, valid_options}
      end

    # Finally handle pagination with combined reset flags and new count
    combined_force_reset = sorting_requires_reset or filtering_requires_reset or force_reset
    pagination_context = socket.assigns.pagination_context

    case PaginationHelpers.resolve_pagination_changes(
           valid_sorting_options,
           params,
           count_all,
           pagination_context,
           combined_force_reset
         ) do
      {:reset_stream, valid_options, page_changed, new_assigns} ->
        languages = FilteredLanguages.list_languages(valid_options)

        socket =
          socket
          |> assign(:options, valid_options)
          |> assign(:count_all, count_all)
          |> assign(new_assigns)
          |> assign(:visible_ids, Enum.map(languages, & &1.id))
          |> stream(:languages, languages, reset: true)

        if page_changed do
          push_patch(socket, to: get_url(valid_options))
        else
          socket
        end

      {:noreset_stream, valid_options} ->
        socket
        |> assign(:options, valid_options)
        # Update count in socket
        |> assign(:count_all, count_all)
    end
  end

  @impl true
  def handle_event("filter", params, socket) do
    options = socket.assigns.options
    filtering_context = socket.assigns.filtering_context

    new_options =
      options
      |> FilteringHelpers.update_filter_options(params, filtering_context)
      |> FilteringHelpers.validate_options(filtering_context)

    socket = push_patch(socket, to: get_url(new_options))
    {:noreply, socket}
  end

  @impl true
  def handle_event("change-per-page", params, socket) do
    options = socket.assigns.options
    pagination_context = socket.assigns.pagination_context
    new_options = PaginationHelpers.update_per_page_option(options, params, pagination_context)
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
    language = FilteredLanguages.get_language!(id)

    case FilteredLanguages.delete_language(language) do
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
        {LivePlaygroundWeb.GridsLive.Filtered.FormComponent, {:created, language}},
        socket
      ) do
    {:processed_created, new_assigns, marked_language} =
      PaginationHelpers.process_created(socket.assigns, language)

    # Check if item matches current filters for appropriate messaging
    matches_current_filter =
      FilteredLanguages.matches_filter?(language, socket.assigns.options)

    message =
      if matches_current_filter do
        "Language created successfully. It has been temporarily added to the top of the list " <>
          "and will be sorted to its correct position on the next page load."
      else
        "Language created successfully. It has been temporarily added to the top of the list " <>
          "but will disappear when you reload as it doesn't match your current filters."
      end

    socket =
      socket
      |> assign(new_assigns)
      |> stream_insert(:languages, marked_language, at: 0)
      |> put_flash(:info, get_flash_message_with_reset_link(message))

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlaygroundWeb.GridsLive.Filtered.FormComponent, {:updated, language}},
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
  def handle_info({LivePlayground.FilteredLanguages, {:created, language}}, socket) do
    if FilteredLanguages.matches_filter?(language, socket.assigns.options) do
      {:processed_created, new_assigns, marked_language} =
        PaginationHelpers.process_created(socket.assigns, language)

      socket =
        socket
        |> assign(new_assigns)
        |> stream_insert(:languages, marked_language, at: 0)
        |> put_flash(
          :info,
          get_flash_message_with_reset_link(
            "A new language was added by another user. It has been temporarily added to the top of the list " <>
              "and will be sorted to its correct position on the next page load."
          )
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(
        {LivePlayground.FilteredLanguages, {:updated, language}},
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
      count_all = FilteredLanguages.count_languages(socket.assigns.options)

      if count_all > socket.assigns.count_all do
        # Item now matches filter - treat like creation
        {:processed_created, new_assigns, marked_language} =
          PaginationHelpers.process_created(socket.assigns, language)

        socket =
          socket
          |> assign(new_assigns)
          |> stream_insert(:languages, marked_language, at: 0)
          |> put_flash(
            :info,
            get_flash_message_with_reset_link(
              "A language was updated by another user and now matches your filters. " <>
              "It has been temporarily added to the top of the list and will be sorted " <>
              "to its correct position on the next page load."
            )
          )

        {:noreply, socket}
      else
        # Item still doesn't match or count decreased (moved out of filter)
        {:noreply, assign(socket, :count_all, count_all)}
      end
    end
  end

  @impl true
  def handle_info(
        {LivePlayground.FilteredLanguages, {:deleted, language}},
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

  defp get_url(options, base_path \\ "/grids/filtered") do
    query_params = merge_filter_params(options)
    query_string = URI.encode_query(query_params)
    "#{base_path}?#{query_string}"
  end

  defp merge_filter_params(options) do
    # First convert special types and remove empty values from the filter map
    filter =
      options
      |> Map.get(:filter, %{})
      |> Enum.map(fn
        {k, v} when is_boolean(v) -> {k, to_string(v)}
        {k, v} -> {k, v}
      end)
      |> Enum.reject(fn {_k, v} -> v == "" or is_nil(v) end)

    # Then merge the filter map with the rest of the options
    options
    |> Map.delete(:filter)
    |> Map.merge(Map.new(filter))
  end

  defp get_pagination_keep_params(options) do
    options
    |> Map.drop([:page, :per_page])
    |> merge_filter_params()
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
