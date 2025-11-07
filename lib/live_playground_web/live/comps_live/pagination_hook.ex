defmodule LivePlaygroundWeb.CompsLive.PaginationHook do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page: 1,
       per_page: 10,
       count_all: 45
     )}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Pagination with Hook
      <:subtitle>
        Implementing Pagination with Hook to Scroll to Top in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def pagination">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="py-10 text-center text-zinc-500">
      Scroll down slightly to observe how the page automatically scrolls back to the top when you navigate to a different page.
    </div>
    <div id="pagination-hook" phx-hook="ScrollToTop">
      <.pagination event="select-page" page={@page} per_page={@per_page} count_all={@count_all} />
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/pagination_hook.ex" />
      <.code_block filename="assets/js/hooks/scroll-to-top.js" />
      <.note icon="hero-information-circle">
        Follow <.link class="underline" navigate={~p"/paginate"}>this recipe</.link>
        to implement a pagination component in database queries.
      </.note>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("select-page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    {:noreply, assign(socket, :page, page)}
  end
end
