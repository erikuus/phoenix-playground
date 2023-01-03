defmodule LivePlaygroundWeb.UploadLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        title: "Upload",
        description: "How to upload file to server in live view"
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""

    """
  end
end
