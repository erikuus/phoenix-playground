defmodule LivePlaygroundWeb.SendAfterLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent

  alias LivePlayground.Sales

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :refresh, 1000)
    {:ok, assign_stats(socket)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.heading>
      Send After
      <:footer>
        How to send message to live view after process
      </:footer>
       <:buttons>
        <.button navigate="/send-interval" color={:secondary}>
          Back to send interval
        </.button>
      </:buttons>
    </.heading>
    <!-- end hiding from live code -->
    <.statset>
      <.stat label="Orders">
        <%= @orders %>
      </.stat>
      <.stat label="Amount">
        <%= @amount %>
      </.stat>
      <.stat label="Satisfaction">
        <%= @satisfaction %>
      </.stat>
    </.statset>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/send_after_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_info(:refresh, socket) do
    socket = assign_stats(socket)
    Process.send_after(self(), :refresh, 1000)
    {:noreply, socket}
  end

  defp assign_stats(socket) do
    assign(socket,
      orders: Sales.orders(),
      amount: Sales.amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
