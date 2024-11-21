defmodule LivePlaygroundWeb.RecipesLive.KeyEvents do
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
        Managing Key Events in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="space-y-4" phx-window-keyup="update">
      <div class="px-6 py-3 bg-gray-100 rounded-lg space-y-4 xl:space-y-0 xl:space-x-4 xl:flex xl:items-center">
        <span>Press "k" for play/pause, "←" for previous, "→" for next. Or type image index (0, 1, 2) and press "Enter" here:</span>
        <.input name="current" type="number" step="1" value={@current} phx-keyup="set-current" phx-key="Enter" class="xl:w-20" />
      </div>
      <img src={"/images/#{Enum.at(@images, @current)}"} class="w-full rounded-lg" />
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/recipes_live/key_events.ex" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/key_events.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("set-current", %{"key" => "Enter", "value" => index}, socket) do
    case Integer.parse(index) do
      {number, ""} when number in 0..2 ->
        {:noreply, assign(socket, :current, number)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("update", %{"key" => "k"}, socket) do
    {:noreply, toggle_play(socket)}
  end

  def handle_event("update", %{"key" => "ArrowRight"}, socket) do
    {:noreply, assign(socket, :current, next(socket))}
  end

  def handle_event("update", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, assign(socket, :current, prev(socket))}
  end

  def handle_event("update", _, socket) do
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    {:noreply, assign(socket, :current, next(socket))}
  end

  defp toggle_play(socket) do
    playing = socket.assigns.playing

    if playing do
      # Stop the timer and update the state to not playing
      :timer.cancel(socket.assigns.timer)
      assign(socket, playing: false, timer: nil)
    else
      # Start the timer and update the state to playing
      {:ok, timer} = :timer.send_interval(1000, self(), :tick)
      assign(socket, playing: true, timer: timer)
    end
  end

  defp next(socket) do
    # Calculates the next index for the image carousel. Uses the `rem` (remainder) function
    # to ensure the index wraps around to the beginning after reaching the end of the list.
    # For example, if `current` is the last index, it wraps around to 0.
    rem(
      socket.assigns.current + 1,
      Enum.count(socket.assigns.images)
    )
  end

  defp prev(socket) do
    # Calculates the previous index for the image carousel. The `rem` function is used to
    # handle wrap-around at the start of the list to the end. By adding the total number
    # of images before applying `rem`, it ensures that the result is always non-negative,
    # allowing the index to cycle back to the last image when `current` is 0.
    rem(
      socket.assigns.current - 1 + Enum.count(socket.assigns.images),
      Enum.count(socket.assigns.images)
    )
  end
end
