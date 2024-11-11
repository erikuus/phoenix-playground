defmodule LivePlaygroundWeb.CompsLive.PaginationPage do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       per_page: 10,
       count_all: 45
     )}
  end

  def handle_params(%{"page" => page}, _url, socket) do
    page = to_integer(page, 1)

    # Keep it simple for component demo
    cond do
      page < 0 -> {:noreply, push_patch(socket, to: ~p"/pagination-page?page=1")}
      page > 5 -> {:noreply, push_patch(socket, to: ~p"/pagination-page?page=5")}
      true -> {:noreply, assign(socket, :page, page)}
    end
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page, 1)}
  end

  defp to_integer(value, _default_value) when is_integer(value), do: value

  defp to_integer(value, default_value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} -> i
      _ -> default_value
    end
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Pagination with Page
      <:subtitle>
        Applying Pagination with Only Page Parameter in LiveView URL
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def pagination">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.pagination patch_path="/pagination-page" page={@page} per_page={@per_page} count_all={@count_all} />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/pagination_page.ex" />
      <.note icon="hero-information-circle">
        Follow <.link class="underline" navigate={~p"/paginate-params"}>this recipe</.link>
        to implement a pagination component in database queries.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end
end
