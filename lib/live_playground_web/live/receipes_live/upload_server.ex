defmodule LivePlaygroundWeb.ReceipesLive.UploadServer do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      File Uploads to Server
      <:subtitle>
        How to upload files to a server in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/upload-cloud"}>
          See also: File Uploads to Cloud <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    """
  end
end
