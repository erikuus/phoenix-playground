defmodule LivePlaygroundWeb.StepsLive.Paginated.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages2
  alias LivePlayground.Languages.Language

  @per_page 10

  @impl true
  def mount(%{"page" => page, "per_page" => per_page}, _session, socket) do
    if connected?(socket), do: Languages2.subscribe()
    options = %{page: page, per_page: per_page}

    socket = assign(socket, :count_all, Languages2.count_languages())
    options = validate_options(socket, options)

    {:ok, init(socket, options)}
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Languages2.subscribe()
    options = %{page: 1, per_page: @per_page}

    socket = assign(socket, :count_all, Languages2.count_languages())

    {:ok, init(socket, options)}
  end

  defp init(socket, options) do
    count_all = socket.assigns.count_all
    per_page = options.per_page
    count_view = min(count_all, per_page)

    socket
    |> assign(:options, options)
    |> assign(:count_all_summary, count_all)
    |> assign(:count_all_pagination, count_all)
    |> assign(:count_view, count_view)
    |> assign(:item_deleted, false)
    |> stream(:languages, Languages2.list_languages(options))
  end

  defp validate_options(socket, options) do
    per_page = to_integer(options.per_page, @per_page)
    page = to_integer(options.page, 1)

    existing_page = get_existing_page(page, per_page, socket.assigns.count_all)
    allowed_per_page = get_allowed_per_page(per_page)

    Map.merge(options, %{page: existing_page, per_page: allowed_per_page})
  end

  defp to_integer(value, _default_value) when is_integer(value), do: value

  defp to_integer(value, default_value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} when i > 0 -> i
      _ -> default_value
    end
  end

  defp to_integer(_value, default_value), do: default_value

  defp get_existing_page(page, per_page, count_all) do
    max_page = ceil_div(count_all, per_page)

    cond do
      # When there are no items, stay on page 1
      max_page == 0 -> 1
      page > max_page -> max_page
      page < 1 -> 1
      true -> page
    end
  end

  defp ceil_div(num, denom) do
    div(num + denom - 1, denom)
  end

  defp get_allowed_per_page(per_page) do
    if per_page in get_per_page_options(), do: per_page, else: @per_page
  end

  defp get_per_page_options() do
    [5, 10, 20, 50, 100]
  end

  @impl true
  def handle_params(params, _url, socket) do
    options = socket.assigns.options || %{}
    per_page = params["per_page"] || options.per_page || @per_page
    page = params["page"] || options.page || 1
    page_before_validation = to_integer(page, 1)
    new_options = validate_options(socket, %{page: page, per_page: per_page})

    if new_options.page != page_before_validation do
      {:noreply, push_patch(socket, to: get_pagination_url(new_options))}
    else
      socket =
        socket
        |> apply_options(socket.assigns.live_action, new_options, false)
        |> apply_action(socket.assigns.live_action, params)

      {:noreply, socket}
    end
  end

  defp apply_options(socket, :index, options, reset_stream) do
    old_options = socket.assigns.options

    socket =
      if reset_stream or options != old_options do
        languages = Languages2.list_languages(options)
        count_view = length(languages)

        socket
        |> assign(:options, options)
        |> assign(:count_view, count_view)
        |> assign(:count_all_summary, socket.assigns.count_all)
        |> assign(:count_all_pagination, socket.assigns.count_all)
        |> assign(:item_deleted, false)
        |> stream(:languages, languages, reset: true)
      else
        socket
      end

    socket
  end

  defp apply_options(socket, _action, _options, _reset_stream) do
    socket
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Language")
    |> assign(:language, Languages2.get_language!(id))
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
  def handle_event("update-pagination", params, socket) do
    params = update_params(params, socket.assigns.options)
    socket = push_patch(socket, to: get_pagination_url(params))
    {:noreply, socket}
  end

  @impl true
  def handle_event("reset-stream", _params, socket) do
    socket =
      socket
      |> clear_flash()
      |> apply_options(:index, socket.assigns.options, true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    language = Languages2.get_language!(id)
    {:ok, _} = Languages2.delete_language(language)

    socket =
      socket
      |> handle_deleted(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link(
          "Language deleted. It will be removed from the list when you navigate away or refresh."
        )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlaygroundWeb.StepsLive.Paginated.FormComponent, {:created, language}},
        socket
      ) do
    socket =
      socket
      |> handle_created(language)
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
        {LivePlaygroundWeb.StepsLive.Paginated.FormComponent, {:updated, language}},
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
        {LivePlayground.Languages2, {:created, language}},
        socket
      ) do
    socket =
      socket
      |> handle_created(language)
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
        {LivePlayground.Languages2, {:updated, language}},
        socket
      ) do
    socket =
      socket
      |> handle_updated(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link("A language was updated by another user.")
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {LivePlayground.Languages2, {:deleted, language}},
        socket
      ) do
    socket =
      socket
      |> handle_deleted(language)
      |> put_flash(
        :info,
        get_flash_message_with_reset_link(
          "A language was deleted by another user. It will be removed from the list when you navigate away or refresh."
        )
      )

    {:noreply, socket}
  end

  defp handle_created(socket, language) do
    language = Map.put(language, :created, true)

    socket
    |> update(:count_all, &(&1 + 1))
    |> update(:count_view, &(&1 + 1))
    |> update(:count_all_summary, &(&1 + 1))
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
    |> assign(:item_deleted, true)
    |> stream_insert(:languages, language)
  end

  defp update_params(%{"per_page" => per_page}, options) do
    %{options | per_page: to_integer(per_page, @per_page)}
  end

  defp update_params(%{"page" => page}, options) do
    %{options | page: to_integer(page, 1)}
  end

  defp get_pagination_url(params, base_path \\ "/steps/paginated") do
    query_string = URI.encode_query(params)
    "#{base_path}?#{query_string}"
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
      Map.get(language, :deleted, false) -> "bg-zinc-50 text-zinc-400 line-through"
      true -> ""
    end
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
end
