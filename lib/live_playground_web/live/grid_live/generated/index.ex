defmodule LivePlaygroundWeb.GridLive.Generated.Index do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Languages
  alias LivePlayground.Languages.Language

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :languages, Languages.list_languages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Language")
    |> assign(:language, Languages.get_language!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Language")
    |> assign(:language, %Language{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Languages")
    |> assign(:language, nil)
  end

  @impl true
  def handle_info(
        {LivePlaygroundWeb.GridLive.Generated.FormComponent, {:saved, language}},
        socket
      ) do
    {:noreply, stream_insert(socket, :languages, language)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    language = Languages.get_language!(id)
    {:ok, _} = Languages.delete_language(language)

    {:noreply, stream_delete(socket, :languages, language)}
  end
end
