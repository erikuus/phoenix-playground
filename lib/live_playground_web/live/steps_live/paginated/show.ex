defmodule LivePlaygroundWeb.StepsLive.Paginated.Show do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    language = Languages.get_language!(id)

    options = Map.delete(params, "id")

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:language, language)
     |> assign(:options, options)}
  end

  defp page_title(:show), do: "Show Language"
  defp page_title(:edit), do: "Edit Language"

  defp get_back_url(params, base_path \\ "/steps/paginated") do
    query_string = URI.encode_query(params)
    "#{base_path}?#{query_string}"
  end
end