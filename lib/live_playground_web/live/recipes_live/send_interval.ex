defmodule LivePlaygroundWeb.RecipesLive.SendInterval do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    timer_ref = if connected?(socket), do: :timer.send_interval(1000, self(), :tick), else: nil

    current_time = DateTime.utc_now()
    expiration_time = DateTime.add(current_time, 2 * 24 * 60 * 60, :second)

    socket =
      assign(socket,
        expiration_time: expiration_time,
        seconds_remaining: seconds_remaining(expiration_time),
        timer_ref: timer_ref
      )

    {:ok, socket}
  end

  def terminate(_reason, socket) do
    if socket.assigns[:timer_ref] do
      :timer.cancel(socket.assigns.timer_ref)
    end

    :ok
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Send Repeatedly
      <:subtitle>
        Sending Messages at Intervals in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="text-2xl font-semibold">
      {format_duration(@seconds_remaining)}
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/recipes_live/send_interval.ex" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/send_interval.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_info(:tick, socket) do
    new_seconds = seconds_remaining(socket.assigns.expiration_time)

    if new_seconds != socket.assigns.seconds_remaining do
      {:noreply, assign(socket, :seconds_remaining, new_seconds)}
    else
      {:noreply, socket}
    end
  end

  defp seconds_remaining(expiration_time) do
    diff = DateTime.diff(expiration_time, DateTime.utc_now(), :second)
    if diff > 0, do: diff, else: 0
  end

  defp format_duration(seconds) when seconds > 0 do
    seconds
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end

  defp format_duration(_), do: "Expired"
end
