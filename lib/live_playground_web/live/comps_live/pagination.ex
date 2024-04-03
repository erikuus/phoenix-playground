defmodule LivePlaygroundWeb.CompsLive.Pagination do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page, 1)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Pagination
      <:subtitle>
        How to Use the Pagination Component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def pagination">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.pagination event="select-page" page={@page} per_page={20} count_all={100} />
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/pagination.ex" />
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
