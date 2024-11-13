defmodule LivePlaygroundWeb.CompsLive.PaginationModifierDemo do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        page: 20,
        per_page: 10,
        count_all: 400
      )

    {:ok, socket, layout: {LivePlaygroundWeb.Layouts, :app}}
  end

  def render(assigns) do
    ~H"""
    <.pagination class="mx-8 my-16" event="select-page" page={@page} per_page={@per_page} count_all={@count_all} />
    <.pagination class="mx-8 my-16" event="select-page" limit={2} page={@page} per_page={@per_page} count_all={@count_all} />
    <.pagination class="mx-8 my-16" event="select-page" modifier="md" page={@page} per_page={@per_page} count_all={@count_all} />
    """
  end

  def handle_event("select-page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    {:noreply, assign(socket, :page, page)}
  end
end
