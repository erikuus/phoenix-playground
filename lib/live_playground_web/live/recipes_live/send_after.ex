defmodule LivePlaygroundWeb.RecipesLive.SendAfter do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Sales

  @refresh_interval 2000

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :refresh, @refresh_interval)
    {:ok, assign_stats(socket)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Send After
      <:subtitle>
        Sending Messages After a Delay in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.stats>
      <:card title="Orders">
        <%= @orders %>
      </:card>
      <:card title="Amount">
        <%= @amount %>
      </:card>
      <:card title="Satisfaction">
        <%= @satisfaction %>
      </:card>
    </.stats>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/send_after.ex" />
      <.code_block filename="lib/live_playground/sales.ex" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/send_after.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_info(:refresh, socket) do
    socket = assign_stats(socket)
    Process.send_after(self(), :refresh, @refresh_interval)
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
