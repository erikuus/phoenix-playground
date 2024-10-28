defmodule LivePlaygroundWeb.StepsLive.Paginated.FormComponent do
  use LivePlaygroundWeb, :live_component

  alias LivePlayground.Languages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage language records in your database.</:subtitle>
      </.header>

      <.simple_form for={@form} id="language-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={@form[:countrycode]} type="text" label="Countrycode" />
        <.input field={@form[:isofficial]} type="checkbox" label="Isofficial" />
        <.input field={@form[:language]} type="text" label="Language" />
        <.input field={@form[:percentage]} type="number" label="Percentage" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Language</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{language: language} = assigns, socket) do
    changeset = Languages.change_language(language)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"language" => language_params}, socket) do
    changeset =
      socket.assigns.language
      |> Languages.change_language(language_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"language" => language_params}, socket) do
    save_language(socket, socket.assigns.action, language_params)
  end

  defp save_language(socket, :edit, language_params) do
    case Languages.update_language(socket.assigns.language, language_params) do
      {:ok, language} ->
        language = Map.put(language, :edit, true)
        notify_parent({:edited, language})

        {:noreply,
         socket
         |> put_flash(:info, "Language updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_language(socket, :new, language_params) do
    case Languages.create_language(language_params) do
      {:ok, language} ->
        language = Map.put(language, :new, true)
        notify_parent({:new, language})

        {:noreply,
         socket
         |> put_flash(
           :info,
           get_flash_message_with_reset_link(
             "Language created successfully. It has been temporarily added to the top of the list and will be sorted to its correct position on the next page load. ",
             socket.assigns.reset_patch
           )
         )
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp get_flash_message_with_reset_link(message, reset_patch) do
    link =
      link(
        "Click here to reload and sort now",
        to: reset_patch,
        data: [phx_link: "patch", phx_link_state: "push"],
        class: "underline"
      )

    [message, link]
  end
end
