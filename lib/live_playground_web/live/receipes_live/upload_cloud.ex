defmodule LivePlaygroundWeb.ReceipesLive.UploadCloud do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      File Uploads to Cloud
      <:subtitle>
        How to upload files to a cloud in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/upload"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: File Uploads UI
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    """
  end
end
