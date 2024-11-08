defmodule LivePlaygroundWeb.StepsLive.Paginated.FormComponent do
  use LivePlaygroundWeb, :live_component

  alias LivePlayground.Languages2

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
    changeset = Languages2.change_language(language)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"language" => language_params}, socket) do
    changeset =
      socket.assigns.language
      |> Languages2.change_language(language_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"language" => language_params}, socket) do
    save_language(socket, socket.assigns.action, language_params)
  end

  defp save_language(socket, :edit, language_params) do
    language = socket.assigns.language

    case Languages2.update_language(language, language_params) do
      {:ok, updated_language} ->
        notify_parent({:updated, updated_language})
        {:noreply, push_patch(socket, to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        if changeset.errors[:lock_version] do
          # Handle stale entry error
          socket =
            socket
            |> put_flash(:error, "This language has been modified by someone else.")
            |> push_patch(to: socket.assigns.patch)

          {:noreply, socket}
        else
          # Handle other validation errors
          {:noreply, assign_form(socket, changeset)}
        end
    end
  end

  defp save_language(socket, :new, language_params) do
    case Languages2.create_language(language_params) do
      {:ok, language} ->
        notify_parent({:created, language})
        {:noreply, push_patch(socket, to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
