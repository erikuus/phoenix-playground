defmodule LivePlaygroundWeb.UploadCloudLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        title: "Cloud Upload",
        description: "How to upload file to Amazon S3 in live view"
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""

    """
  end
end
