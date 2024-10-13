defmodule LivePlaygroundWeb.StepsLive.Paginated.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages2
  alias LivePlayground.Languages.Language

  @per_page 10

  @impl true
  def mount(%{"page" => page, "per_page" => per_page}, _session, socket) do
    options = %{page: page, per_page: per_page}

    {:ok, assign(socket, :options, options)}
  end

  @impl true
  def mount(_params, _session, socket) do
    options = %{page: 1, per_page: @per_page}

    {:ok, assign(socket, :options, options)}
  end

  @impl true
  def handle_params(%{"sort" => "reset"} = params, _url, socket) do
    socket = apply_options(params, socket, true)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = apply_options(params, socket)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_options(params, socket, reset_stream \\ false) do
    options = socket.assigns.options
    count_all = Languages2.count_languages()
    per_page = to_integer(params["per_page"] || options.per_page || @per_page, @per_page)
    page = to_integer(params["page"] || options.page || 1, 1)

    existing_page = get_existing_page(page, per_page, count_all)
    allowed_per_page = get_allowed_per_page(per_page)

    new_options = Map.merge(options, %{page: existing_page, per_page: allowed_per_page})

    languages = Languages2.list_languages(new_options)
    count_view = length(languages)

    socket =
      socket
      |> assign(:count_all, count_all)
      |> assign(:options, new_options)
      |> assign(:item_deleted, false)
      |> assign(:count_view, count_view)

    # Reset the stream if:
    # 1. `reset_stream` is explicitly flagged or options have changed.
    # 2. The selected page becomes invalid due to a change in the total number of items, such as after deletions.
    #    This handles an edge case where the user deletes all items on a page (e.g., page 10 of 11), reducing the
    #    total number of pages. If the user then attempts to navigate to the now non-existent last page (page 11),
    #    the system recalculates the selected page to ensure it falls within the valid range (now page 10).
    #    Because the pagination options themselves (like `per_page` and `page`) are unchanged, we introduce this
    #    extra condition to force the reset when the selected page is recalculated, ensuring the stream shows valid
    #    data for the updated page.
    socket =
      cond do
        reset_stream or new_options != options or page != existing_page ->
          socket |> stream(:languages, languages, reset: true)

        not Map.has_key?(socket.assigns[:streams] || %{}, :languages) ->
          socket |> stream(:languages, languages)

        true ->
          socket
      end

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
  def handle_info(
        {LivePlaygroundWeb.StepsLive.Paginated.FormComponent, {:new, language}},
        socket
      ) do
    {:noreply,
     socket
     |> update(:count_view, &(&1 + 1))
     |> stream_insert(:languages, language, at: 0)}
  end

  @impl true
  def handle_info(
        {LivePlaygroundWeb.StepsLive.Paginated.FormComponent, {:edited, language}},
        socket
      ) do
    {:noreply, stream_insert(socket, :languages, language)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    language = Languages2.get_language!(id)
    {:ok, _} = Languages2.delete_language(language)

    {:noreply,
     socket
     |> assign(:item_deleted, true)
     |> put_flash(
       :info,
       flash_message_with_reset_link(
         "Item deleted. It will be removed from the list when you navigate away or refresh. ",
         get_pagination_url(%{sort: "reset"}, ~p"/steps/paginated")
       )
     )}
  end

  def handle_event("update-pagination", params, socket) do
    params = update_params(params, socket.assigns.options)
    socket = push_patch(socket, to: get_pagination_url(params))
    {:noreply, socket}
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

  defp get_allowed_per_page(per_page) do
    if per_page in get_per_page_options(), do: per_page, else: @per_page
  end

  defp get_per_page_options() do
    [5, 10, 20, 50, 100]
  end

  defp get_page_summary(count_all, page, per_page, stream_size) do
    start = (page - 1) * per_page + 1
    ending = min(start + stream_size - 1, count_all)

    "Showing #{start} - #{ending} of #{count_all}."
  end

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

  defp to_integer(value, _default_value) when is_integer(value), do: value

  defp to_integer(value, default_value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} -> i
      :error -> default_value
    end
  end

  defp to_integer(_value, default_value), do: default_value

  def row_class(language) do
    cond do
      Map.get(language, :new, false) -> "bg-green-50"
      Map.get(language, :edit, false) -> "bg-blue-50"
      true -> ""
    end
  end

  defp flash_message_with_reset_link(message, reset_patch) do
    link =
      link(
        "Click here to reload and sort now",
        to: reset_patch,
        data: [phx_link: "patch", phx_link_state: "push"],
        class: "underline"
      )

    [message, link]
  end
end
