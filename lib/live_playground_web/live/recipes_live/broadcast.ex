defmodule LivePlaygroundWeb.RecipesLive.Broadcast do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  @country_id 228

  def mount(_params, _session, socket) do
    if connected?(socket), do: Countries.subscribe(@country_id)

    country = Countries.get_country!(@country_id)
    {:ok, assign(socket, :country, country)}
  end

  def terminate(_reason, _socket) do
    Countries.unsubscribe(@country_id)
    :ok
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Real-Time Updates
      <:subtitle>
        Broadcasting Real-Time Updates in LiveView
      </:subtitle>

      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="mb-12">
      <.simple_form for={get_country_form(@country)} phx-submit="save">
        <.input field={get_country_form(@country)[:headofstate]} type="text" label="Head of state" autocomplete="off" />
        <:actions>
          <.button>Update Head of State</.button>
        </:actions>
      </.simple_form>
    </div>
    <div id="country" phx-update="replace">
      <.list class="mt-6 mb-16 ml-1">
        <:item title="Name">{@country.name}</:item>
        <:item title="The head of state">
          {@country.headofstate}
        </:item>
        <:item title="Population">
          {Number.Delimit.number_to_delimited(@country.population, precision: 0, delimiter: " ")}
        </:item>
        <:item title="GNP">
          {Number.Delimit.number_to_delimited(@country.gnp, precision: 0, delimiter: " ")}
        </:item>
        <:item title="Life expectancy">
          {Number.Delimit.number_to_delimited(@country.lifeexpectancy, precision: 2)}
        </:item>
      </.list>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.note icon="hero-information-circle">
        <a target="_blank" href="/broadcast" class="underline">
          Open this page in multiple browser tabs or windows.
        </a>
        Change the head of state to see real-time updates in other tabs.
      </.note>
      <.code_block filename="lib/live_playground_web/live/recipes_live/broadcast.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# broadcast" to="# endbroadcast" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/broadcast.html" />
    <!-- end hiding from live code -->
    """
  end

  defp get_country_form(country) do
    country
    |> Countries.change_country()
    |> to_form()
  end

  def handle_event("save", %{"country" => params}, socket) do
    case Countries.update_country_broadcast(socket.assigns.country, params) do
      {:ok, country} ->
        socket =
          socket
          |> assign(:country, country)
          |> put_flash(:info, "Head of state updated successfully.")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_info({LivePlayground.Countries, {:update_country, updated_country}}, socket) do
    if country_changed?(socket.assigns.country, updated_country) do
      socket =
        socket
        |> assign(:country, updated_country)
        |> put_flash(:info, "Country data updated by another user.")

      {:noreply, socket}
    else
      {:noreply, assign(socket, :country, updated_country)}
    end
  end

  defp country_changed?(current, updated) do
    current.headofstate != updated.headofstate ||
      current.population != updated.population ||
      current.gnp != updated.gnp ||
      current.lifeexpectancy != updated.lifeexpectancy
  end
end
