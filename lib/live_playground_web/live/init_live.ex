defmodule LivePlaygroundWeb.InitLive do
  use LivePlaygroundWeb, :live_view

  def on_mount(:default, _params, _session, socket) do
    socket =
      attach_hook(socket, :set_current_path, :handle_params, fn
        _params, url, socket ->
          {:cont, assign(socket, current_path: URI.parse(url).path)}
      end)

    {:cont, socket}
  end

  def render(assigns) do
    ~H"""

    """
  end
end
