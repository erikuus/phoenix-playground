defmodule LivePlaygroundWeb.StepsLive.Paginated.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages2
  alias LivePlayground.Languages.Language

  @per_page 10

  @impl true
  def mount(%{"page" => page, "per_page" => per_page}, _session, socket) do
    count = Languages2.count_languages()

    page = to_integer(page, 1)
    per_page = to_integer(per_page, @per_page)
    existing_page = get_existing_page(page, per_page, count)
    allowed_per_page = get_allowed_per_page(per_page)
    options = %{page: existing_page, per_page: allowed_per_page}

    {:ok, init_page(socket, count, options)}
  end

  @impl true
  def mount(_params, _session, socket) do
    count = Languages2.count_languages()
    options = %{page: 1, per_page: @per_page}

    {:ok, init_page(socket, count, options)}
  end

  defp init_page(socket, count, options) do
    socket
    |> assign(:count, count)
    |> assign(:options, options)
    |> stream(:languages, Languages2.list_languages(options))
  end

  @impl true
  def handle_params(%{"page" => page, "per_page" => per_page} = params, _url, socket) do
    page = to_integer(page, 1)
    per_page = to_integer(per_page, @per_page)
    existing_page = get_existing_page(page, per_page, socket.assigns.count)
    allowed_per_page = get_allowed_per_page(per_page)

    options = %{page: existing_page, per_page: allowed_per_page}

    socket =
      if options != socket.assigns.options do
        change_page(socket, options)
      else
        socket
      end

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp change_page(socket, options) do
    socket
    |> assign(:options, options)
    |> stream(:languages, Languages2.list_languages(options), reset: true)
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
        {LivePlaygroundWeb.StepsLive.Paginated.FormComponent, {:saved, language}},
        socket
      ) do
    {:noreply, stream_insert(socket, :languages, language, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    language = Languages2.get_language!(id)
    {:ok, _} = Languages2.delete_language(language)

    {:noreply, stream_delete(socket, :languages, language)}
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

  defp get_existing_page(page, per_page, count) do
    max_page = ceil_div(count, per_page)

    cond do
      page > max_page -> max_page
      page < 1 -> 1
      true -> page
    end
  end

  defp ceil_div(num, denom) do
    div(num + denom - 1, denom)
  end

  defp to_integer(value, default_value) do
    case Integer.parse(value) do
      {i, _} -> i
      :error -> default_value
    end
  end

  def row_class(language) do
    cond do
      Map.get(language, :new, false) -> "bg-green-50"
      Map.get(language, :edit, false) -> "bg-blue-50"
      true -> ""
    end
  end
end
