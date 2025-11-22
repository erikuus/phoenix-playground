defmodule LivePlaygroundWeb.GridsLive.Sorted.FormComponent do
  use LivePlaygroundWeb, :live_component

  alias LivePlayground.SortedLanguages
  alias LivePlayground.Countries

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage language records in your database.</:subtitle>
      </.header>
      <.alert flash={@flash} flash_key={:lock} title="Concurrent update detected" kind={:error} close={false} class="mt-6 text-sm" />
      <div class="mt-6">
        <.simple_form for={@form} id="language-form" phx-target={@myself} phx-change="validate" phx-submit="save">
          <.input field={@form[:lock_version]} type="hidden" />
          <.input field={@form[:countrycode]} type="text" label="Countrycode" autocomplete="off" list="matches" phx-debounce="500" />
          <.input field={@form[:isofficial]} type="checkbox" label="Isofficial" />
          <.input field={@form[:language]} type="text" label="Language" phx-debounce="500" />
          <.input field={@form[:percentage]} type="number" label="Percentage" step="any" min={0} max={100} />
          <:actions>
            <.button phx-disable-with="Saving...">Save Language</.button>
          </:actions>
        </.simple_form>
      </div>
      <datalist id="matches">
        <option :for={match <- @matches} value={match.code} />
      </datalist>
    </div>
    """
  end

  @impl true
  def update(%{language: language} = assigns, socket) do
    changeset = SortedLanguages.change_language(language)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:matches, [])
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"language" => language_params}, socket) do
    # Suggestions logic
    countrycode = Map.get(language_params, "countrycode", "")
    matches = if countrycode == "", do: [], else: Countries.list_code_country(countrycode)
    validate_countrycode_exists = matches == []

    # Validation logic
    changeset =
      socket.assigns.language
      |> SortedLanguages.change_language(language_params,
        validate_countrycode_exists: validate_countrycode_exists
      )
      |> Map.put(:action, :validate)

    # Update socket
    {:noreply,
     socket
     |> assign_form(changeset)
     |> assign(:matches, matches)}
  end

  @impl true
  def handle_event("save", %{"language" => language_params}, socket) do
    save_language(socket, socket.assigns.action, language_params)
  end

  defp save_language(socket, :edit, language_params) do
    language = socket.assigns.language

    case SortedLanguages.update_language(language, language_params) do
      {:ok, updated_language} ->
        notify_parent({:updated, updated_language})
        {:noreply, push_patch(socket, to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        if changeset.errors[:lock_version] do
          # Fetch the latest version and merge with current changes
          latest_language = SortedLanguages.get_language!(language.id)

          socket =
            socket
            |> assign(:language, latest_language)
            |> assign_form(SortedLanguages.change_language(latest_language))
            |> put_flash(
              :lock,
              "This record has been modified. We've loaded the latest version. Please review and submit again."
            )

          {:noreply, socket}
        else
          # Handle other validation errors
          {:noreply, assign_form(socket, changeset)}
        end
    end
  end

  defp save_language(socket, :new, language_params) do
    case SortedLanguages.create_language(language_params) do
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
