defmodule LivePlaygroundWeb.CompsLive.Tabs do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"tab" => tab}, _url, socket) do
    {:noreply, assign(socket, :current_tab, tab)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :current_tab, "overview")}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Tabs
      <:subtitle>
        How to use Tabs component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def tabs">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.tabs>
      <:tab :for={tab <- get_tabs(@current_tab)} path={tab.path} active={tab.active}>
        <%= tab.title %>
      </:tab>
    </.tabs>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/tabs.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp get_tabs(current_tab) do
    [
      %{
        title: "Overview",
        path: ~p"/tabs?#{[tab: "overview"]}",
        active: is_active?(current_tab, "overview")
      },
      %{
        title: "Features",
        path: ~p"/tabs?#{[tab: "features"]}",
        active: is_active?(current_tab, "features")
      },
      %{
        title: "Pricing",
        path: ~p"/tabs?#{[tab: "pricing"]}",
        active: is_active?(current_tab, "pricing")
      },
      %{
        title: "FAQs",
        path: ~p"/tabs?#{[tab: "faqs"]}",
        active: is_active?(current_tab, "faqs")
      },
      %{
        title: "Testimonials",
        path: ~p"/tabs?#{[tab: "testimonials"]}",
        active: is_active?(current_tab, "testimonials")
      },
      %{
        title: "Contact",
        path: ~p"/tabs?#{[tab: "contact"]}",
        active: is_active?(current_tab, "contact")
      }
    ]
  end

  defp is_active?(current_tab, tab) do
    if current_tab == tab, do: true, else: false
  end
end
