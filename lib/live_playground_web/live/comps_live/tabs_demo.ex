defmodule LivePlaygroundWeb.CompsLive.TabsDemo do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {LivePlaygroundWeb.Layouts, :app}}
  end

  def handle_params(%{"tab" => tab}, _url, socket) do
    {:noreply, assign(socket, :current_tab, tab)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :current_tab, "overview")}
  end

  def render(assigns) do
    ~H"""
    <.tabs class="m-8" modifier="md">
      <:tab :for={tab <- get_tabs(@current_tab)} path={tab.path} active={tab.active}>
        <%= tab.title %>
      </:tab>
    </.tabs>
    <.tabs id="tabs2" class="m-8">
      <:tab :for={tab <- get_tabs(@current_tab)} path={tab.path} active={tab.active}>
        <%= tab.title %>
      </:tab>
    </.tabs>
    """
  end

  defp get_tabs(current_tab) do
    [
      %{
        title: "Overview",
        path: ~p"/tabs-demo?#{[tab: "overview"]}",
        active: is_active?(current_tab, "overview")
      },
      %{
        title: "Features",
        path: ~p"/tabs-demo?#{[tab: "features"]}",
        active: is_active?(current_tab, "features")
      },
      %{
        title: "Pricing",
        path: ~p"/tabs-demo?#{[tab: "pricing"]}",
        active: is_active?(current_tab, "pricing")
      },
      %{
        title: "FAQs",
        path: ~p"/tabs-demo?#{[tab: "faqs"]}",
        active: is_active?(current_tab, "faqs")
      },
      %{
        title: "Testimonials",
        path: ~p"/tabs-demo?#{[tab: "testimonials"]}",
        active: is_active?(current_tab, "testimonials")
      },
      %{
        title: "Contact",
        path: ~p"/tabs-demo?#{[tab: "contact"]}",
        active: is_active?(current_tab, "contact")
      }
    ]
  end

  defp is_active?(current_tab, tab) do
    if current_tab == tab, do: true, else: false
  end
end
