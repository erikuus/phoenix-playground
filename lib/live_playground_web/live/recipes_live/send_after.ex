defmodule LivePlaygroundWeb.RecipesLive.SendAfter do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Sales

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :refresh, 1000)
    {:ok, assign_stats(socket)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Send After
      <:subtitle>
        How to send message in LiveView after given milliseconds
      </:subtitle>
      <:actions>
        <.link navigate={~p"/send-interval"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Send Repeatedly
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.stat>
      <:card title="Orders">
        <%= @orders %>
      </:card>
      <:card title="Amount">
        <%= @amount %>
      </:card>
      <:card title="Satisfaction">
        <%= @satisfaction %>
      </:card>
    </.stat>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/recipes_live/send_after.ex")) %>
      <%= raw(code("lib/live_playground/sales.ex")) %>
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
