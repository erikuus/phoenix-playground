defmodule LivePlaygroundWeb.CompsLive.PaginationPerPage do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count_all, 45)}
  end

  def handle_params(params, _url, socket) do
    page = to_integer(Map.get(params, "page", "1"), 1)
    per_page = to_integer(Map.get(params, "per_page", "10"), 10)

    allowed_per_page = if per_page in [5, 10, 20], do: per_page, else: 10
    existing_page = get_existing_page(page, allowed_per_page, socket.assigns.count_all)

    if page != existing_page or per_page != allowed_per_page do
      {:noreply,
       push_patch(socket,
         to: ~p"/pagination-per-page?#{[page: existing_page, per_page: allowed_per_page]}"
       )}
    else
      {:noreply, assign(socket, page: page, per_page: per_page)}
    end
  end

  defp to_integer(value, _default_value) when is_integer(value), do: value

  defp to_integer(value, default_value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} -> i
      _ -> default_value
    end
  end

  defp to_integer(_value, default_value), do: default_value

  defp get_existing_page(page, per_page, count_all) do
    max_page = ceil_div(count_all, per_page)

    cond do
      max_page == 0 -> 1
      page > max_page -> max_page
      page < 1 -> 1
      true -> page
    end
  end

  defp ceil_div(_num, 0), do: 0
  defp ceil_div(num, denom), do: div(num + denom - 1, denom)

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Pagination with PerPage
      <:subtitle>
        Integrating Pagination with Both Page and PerPage in LiveView URL
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def pagination">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.pagination
      patch_path="/pagination-per-page"
      page={@page}
      per_page={@per_page}
      count_all={@count_all}
      params_per_page_key="per_page"
    />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/pagination_per_page.ex" />
      <.note icon="hero-information-circle">
        Follow <.link class="underline" navigate={~p"/paginate-params"}>this recipe</.link>
        to implement a pagination component in database queries.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
