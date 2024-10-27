defmodule LivePlaygroundWeb.StepsLive.Paginated.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages2
  alias LivePlayground.Languages.Language

  @per_page 10

  @impl true
  def mount(%{"page" => page, "per_page" => per_page}, _session, socket) do
    options = %{page: page, per_page: per_page}

    {:ok, init(socket, options)}
  end

  @impl true
  def mount(_params, _session, socket) do
    options = %{page: 1, per_page: @per_page}

    {:ok, init(socket, options)}
  end

  defp init(socket, options) do
    count_all_real = Languages2.count_languages()
    count_all_visible = count_all_real

    socket
    |> assign(:options, options)
    |> assign(:count_all_real, count_all_real)
    |> assign(:count_all_visible, count_all_visible)
  end

  @impl true
  def handle_params(%{"sort" => "reset"} = params, _url, socket) do
    socket =
      socket
      |> apply_options(socket.assigns.live_action, params, true)
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> apply_options(socket.assigns.live_action, params, false)
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_options(socket, :index, params, reset_stream) do
    options = socket.assigns.options

    per_page = to_integer(params["per_page"] || options.per_page || @per_page, @per_page)
    page = to_integer(params["page"] || options.page || 1, 1)

    existing_page = get_existing_page(page, per_page, socket.assigns.count_all_visible)
    allowed_per_page = get_allowed_per_page(per_page)

    new_options = Map.merge(options, %{page: existing_page, per_page: allowed_per_page})

    languages = Languages2.list_languages(new_options)
    count_view = length(languages)

    socket =
      socket
      |> assign(:options, new_options)
      |> assign(:count_view, count_view)

    socket =
      cond do
        reset_stream or new_options != options or page != existing_page ->
          socket
          |> assign(:item_deleted, false)
          |> assign(:count_all_visible, socket.assigns.count_all_real)
          |> stream(:languages, languages, reset: true)

        not Map.has_key?(socket.assigns[:streams] || %{}, :languages) ->
          socket
          |> assign(:item_deleted, false)
          |> stream(:languages, languages)

        true ->
          socket
      end

    socket
  end

  defp apply_options(socket, _, _, _) do
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
     |> update(:count_all_real, &(&1 + 1))
     |> update(:count_all_visible, &(&1 + 1))
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
     |> update(:count_all_real, &(&1 - 1))
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

  defp row_class(language) do
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
