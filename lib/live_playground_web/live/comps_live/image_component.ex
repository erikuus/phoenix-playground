defmodule LivePlaygroundWeb.CompsLive.ImageComponent do
  use LivePlaygroundWeb, :live_component

  def mount(socket) do
    socket =
      assign(socket,
        images: [],
        current: 0
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl font-bold leading-7">
        <%= @title %>
      </h1>
      <div class="my-6 space-y-3">
        <img src={"/images/#{Enum.at(@images, @current)}"} class="w-full" />
      </div>
      <div class="flex space-x-1">
        <.button phx-click="prev" phx-target={@myself}><.icon name="hero-arrow-left-circle" class="h-6 w-6" /></.button>
        <.button phx-click="next" phx-target={@myself}><.icon name="hero-arrow-right-circle" class="h-6 w-6" /></.button>
      </div>
    </div>
    """
  end

  def handle_event("prev", _, socket) do
    {:noreply, assign(socket, current: prev(socket))}
  end

  def handle_event("next", _, socket) do
    {:noreply, assign(socket, current: next(socket))}
  end

  defp next(socket) do
    rem(
      socket.assigns.current + 1,
      Enum.count(socket.assigns.images)
    )
  end

  defp prev(socket) do
    rem(
      socket.assigns.current - 1 + Enum.count(socket.assigns.images),
      Enum.count(socket.assigns.images)
    )
  end
end
