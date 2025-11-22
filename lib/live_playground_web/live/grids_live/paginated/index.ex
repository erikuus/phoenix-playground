defmodule LivePlaygroundWeb.GridsLive.Paginated.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.PaginatedLanguages
  alias LivePlayground.PaginatedLanguages.Language

  @per_page 10

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: PaginatedLanguages.subscribe()

    socket = assign(socket, :count_all, PaginatedLanguages.count_languages())

    options = convert_params(%{}, params)
    valid_options = validate_options(socket, options)

    if options != valid_options do
      {:ok, push_navigate(socket, to: get_pagination_url(valid_options))}
    else
      {:ok, init(socket, valid_options)}
    end
  end

  @impl true
  def terminate(_reason, _socket) do
    PaginatedLanguages.unsubscribe()
    :ok
  end

  defp convert_params(options, %{"page" => page, "per_page" => per_page} = _params) do
    page = to_integer(page, 0)
    per_page = to_integer(per_page, 0)
    Map.merge(options, %{page: page, per_page: per_page})
  end

  defp convert_params(options, %{"page" => page} = _params) do
    page = to_integer(page, 0)
    per_page = 0
    Map.merge(options, %{page: page, per_page: per_page})
  end

  defp convert_params(options, %{"per_page" => per_page} = _params) do
    page = 0
    per_page = to_integer(per_page, 0)
    Map.merge(options, %{page: page, per_page: per_page})
  end

  defp convert_params(%{page: _, per_page: _} = options, _params) do
    options
  end

  defp convert_params(options, _params) do
    Map.merge(options, %{page: 0, per_page: 0})
  end

  defp to_integer(value, _default_value) when is_integer(value), do: value

  defp to_integer(value, default_value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} when i > 0 -> i
      _ -> default_value
    end
  end

  defp to_integer(_value, default_value), do: default_value

  defp validate_options(socket, options) do
    existing_page = get_existing_page(options.page, options.per_page, socket.assigns.count_all)
    allowed_per_page = get_allowed_per_page(options.per_page)

    Map.merge(options, %{page: existing_page, per_page: allowed_per_page})
  end

  defp get_existing_page(page, per_page, count_all) do
    # Use max/2 to ensure per_page is at least 1 to avoid division by zero
    safe_per_page = max(per_page, 1)
    max_page = ceil_div(count_all, safe_per_page)

    cond do
      # When there are no items, stay on page 1
      max_page == 0 -> 1
      page > max_page -> max_page
      page < 1 -> 1
      true -> page
    end
  end

  defp ceil_div(_num, 0), do: 0
  defp ceil_div(num, denom), do: div(num + denom - 1, denom)

  defp get_allowed_per_page(per_page) do
    if per_page in get_per_page_options(), do: per_page, else: @per_page
  end

  defp get_per_page_options() do
    [5, 10, 20, 50, 100]
  end

  defp init(socket, options) do
    count_all = socket.assigns.count_all
    per_page = options.per_page
    count_visible_rows = min(count_all, per_page)
    languages = PaginatedLanguages.list_languages(options)

    socket
    |> assign(:options, options)
    |> assign(:count_all_summary, count_all)
    |> assign(:count_all_pagination, count_all)
    |> assign(:count_visible_rows, count_visible_rows)
    |> assign(:pending_deletion, false)
    |> assign(:visible_ids, Enum.map(languages, & &1.id))
    |> stream(:languages, languages)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Language")
    |> assign(:language, PaginatedLanguages.get_language!(id))
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

    new_options = convert_params(options, params)
    valid_options = validate_options(socket, new_options)

    reset_needed =
      force_reset or valid_options != options or valid_options.page != new_options.page

    page_changed = valid_options.page != new_options.page

    socket =
      if reset_needed do
        languages = PaginatedLanguages.list_languages(valid_options)
        count_visible_rows = length(languages)

        socket
        |> assign(:options, valid_options)
        |> assign(:count_visible_rows, count_visible_rows)
        |> assign(:count_all_summary, socket.assigns.count_all)
        |> assign(:count_all_pagination, socket.assigns.count_all)
        |> assign(:pending_deletion, false)
        |> assign(:visible_ids, Enum.map(languages, & &1.id))
        |> stream(:languages, languages, reset: true)
        |> (&if(page_changed,
              do: push_patch(&1, to: get_pagination_url(valid_options)),
              else: &1
            )).()
      else
        socket
      end

    socket
  end

  @impl true
  def handle_event("change-per-page", params, socket) do
    per_page = to_integer(params["per_page"], @per_page)
    options = %{socket.assigns.options | per_page: per_page}
    socket = push_patch(socket, to: get_pagination_url(options))
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
    language = PaginatedLanguages.get_language!(id)

    case PaginatedLanguages.delete_language(language) do
      {:ok, deleted_language} ->
        {:noreply,
         socket
         |> handle_deleted(deleted_language)
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
        {LivePlaygroundWeb.GridsLive.Paginated.FormComponent, {:created, language}},
        socket
      ) do
    socket =
      socket
      |> handle_created(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link(
          "Language created successfully. It has been temporarily added to the top of
          the list and will be sorted to its correct position on the next page load."
        )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlaygroundWeb.GridsLive.Paginated.FormComponent, {:updated, language}},
        socket
      ) do
    socket =
      socket
      |> handle_updated(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link("Language updated successfully.")
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlayground.PaginatedLanguages, {:created, language}},
        socket
      ) do
    socket =
      socket
      |> handle_created(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link(
          "A new language was added by another user. It has been temporarily added to the top
          of the list and will be sorted to its correct position on the next page load."
        )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlayground.PaginatedLanguages, {:updated, language}},
        socket
      ) do
    if language.id in socket.assigns.visible_ids do
      socket =
        socket
        |> handle_updated(language)
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
        {LivePlayground.PaginatedLanguages, {:deleted, language}},
        socket
      ) do
    if language.id in socket.assigns.visible_ids do
      socket = handle_deleted(socket, language)

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
              "A language was deleted by another user. It will be removed from the list when you
              navigate away or refresh."
            )
          )

        {:noreply, socket}
      end
    else
      {:noreply, update(socket, :count_all, &(&1 - 1))}
    end
  end

  defp handle_created(socket, language) do
    language = Map.put(language, :created, true)

    socket
    |> update(:count_all, &(&1 + 1))
    |> update(:count_visible_rows, &(&1 + 1))
    |> update(:count_all_summary, &(&1 + 1))
    |> update(:visible_ids, &[language.id | &1])
    |> stream_insert(:languages, language, at: 0)
  end

  defp handle_updated(socket, language) do
    language = Map.put(language, :updated, true)
    stream_insert(socket, :languages, language)
  end

  defp handle_deleted(socket, language) do
    language = Map.put(language, :deleted, true)

    socket
    |> update(:count_all, &(&1 - 1))
    |> assign(:pending_deletion, true)
    |> stream_insert(:languages, language)
  end

  defp get_pagination_url(options, base_path \\ "/grids/paginated") do
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

  defp get_page_summary(count_all, page, per_page, stream_size) do
    start = (page - 1) * per_page + 1
    ending = min(start + stream_size - 1, count_all)

    "Showing #{start} - #{ending} of #{count_all}."
  end

  defp get_row_class(language) do
    cond do
      Map.get(language, :created, false) -> "bg-green-50"
      Map.get(language, :updated, false) -> "bg-blue-50"
      Map.get(language, :deleted, false) -> "bg-zinc-50 !text-zinc-400 line-through"
      true -> ""
    end
  end

  def format_percentage(value, precision \\ 1) do
    Number.Percentage.number_to_percentage(value, precision: precision)
  end
end
