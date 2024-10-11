defmodule LivePlaygroundWeb.StepsLive.Paginated.Show do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages

  @per_page 10

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    language = Languages.get_language!(id)

    per_page = params["per_page"] || @per_page
    page = params["page"] || 1
    options = %{page: page, per_page: per_page}

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:language, language)
     |> assign(:options, options)}
  end

  defp page_title(:show), do: "Show Language"
  defp page_title(:edit), do: "Edit Language"

  defp get_back_url(params) do
    query_string = URI.encode_query(params)
    "/steps/paginated?#{query_string}"
  end
end
