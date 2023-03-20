defmodule LivePlaygroundWeb.InitLive do
  use LivePlaygroundWeb, :live_view

  def on_mount(:default, _params, _session, socket) do
    socket =
      attach_hook(socket, :set_current_path, :handle_params, fn
        _params, url, socket ->
          {:cont, assign(socket, page_title: page_title(URI.parse(url).path))}
      end)

    {:cont, socket}
  end

  defp page_title(path) do
    Map.get(
      %{
        "/clicks" => "Clicks",
        "/changes" => "Changes",
        "/navigate" => "Navigate",
        "/send-interval" => "Send",
        "/autocomplete" => "Autocomplete",
        "/search" => "Search",
        "/filter" => "Filter",
        "/modals" => "Modals",
        "/upload" => "Upload"
      },
      path
    )
  end

  def render(assigns) do
    ~H"""

    """
  end
end
