defmodule LivePlaygroundWeb.KeyEventsLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        images: ["DSC02232.jpg", "DSC02234.jpg", "DSC02235.jpg"],
        current: 0,
        playing: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Key Events
      <:subtitle>
        How to handle key events in LiveView
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <div class="space-y-4" phx-window-keyup="update">
      <div class="space-y-4 xl:space-y-0 xl:space-x-4 xl:flex xl:items-center">
        <.alert>
          Press "k" for play/pause, "←" for previous, "→" for next. Or type image index (0, 1, 2) and press "Enter" here:
        </.alert>
        <.input name="current" type="number" step="1" value={@current} phx-keyup="set-current" phx-key="Enter" class="xl:w-20" />
      </div>
      <img src={"/images/#{Enum.at(@images, @current)}"} class="w-full rounded-lg" />
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/key_events_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("set-current", %{"key" => "Enter", "value" => index}, socket) do
    index = String.to_integer(index)
    new_current = if index in [0, 1, 2], do: index, else: 0
    {:noreply, assign(socket, :current, new_current)}
  end

  def handle_event("update", %{"key" => "ArrowRight"}, socket) do
    {:noreply, assign(socket, :current, next(socket))}
  end

  def handle_event("update", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, assign(socket, :current, prev(socket))}
  end

  def handle_event("update", %{"key" => "k"}, socket) do
    socket = update(socket, :playing, fn playing -> !playing end)

    socket =
      if socket.assigns.playing do
        {:ok, timer} = :timer.send_interval(1000, self(), :tick)
        assign(socket, :timer, timer)
      else
        :timer.cancel(socket.assigns.timer)
        assign(socket, :timer, nil)
      end

    {:noreply, socket}
  end

  def handle_event("update", _, socket) do
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket = assign(socket, :current, next(socket))
    {:noreply, socket}
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
