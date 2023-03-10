defmodule LivePlaygroundWeb.SendIntervalLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    expiration_time = Timex.shift(Timex.now(), days: 2)

    socket =
      assign(socket,
        expiration_time: expiration_time,
        seconds_remaining: seconds_remaining(expiration_time)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Send Interval
      <:subtitle>
        How to send interval message to live view
      </:subtitle>
      <:actions>
        <.link navigate={~p"/send-after"}>
          Try send after
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.card class="text-2xl text-center text-gray-900 font-semibold p-10">
      <%= format_duration(@seconds_remaining) %>
    </.card>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/send_interval_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_info(:tick, socket) do
    socket =
      assign(
        socket,
        :seconds_remaining,
        seconds_remaining(socket.assigns.expiration_time)
      )

    {:noreply, socket}
  end

  defp seconds_remaining(expiration_time) do
    case Timex.compare(expiration_time, Timex.now()) do
      1 -> Timex.diff(expiration_time, Timex.now(), :second)
      _ -> 0
    end
  end

  defp format_duration(seconds) when seconds > 0 do
    seconds
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end

  defp format_duration(_), do: "Expired"
end
