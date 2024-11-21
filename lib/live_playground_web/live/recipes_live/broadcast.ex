defmodule LivePlaygroundWeb.RecipesLive.Broadcast do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  @country_id 228

  def mount(_params, _session, socket) do
    if connected?(socket), do: Countries.subscribe(@country_id)

    socket = reset_edit_form(socket)

    try do
      country = Countries.get_country!(@country_id)
      {:ok, assign(socket, :country, country)}
    rescue
      Ecto.NoResultsError ->
        {:ok, assign(socket, :country, nil)}
    end
  end

  def terminate(_reason, _socket) do
    # Ensure we unsubscribe when the LiveView is terminated to clean up resources
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
    <%= country_details(assigns) %>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/broadcast.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# broadcast" to="# endbroadcast" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/broadcast.html" />
    <!-- end hiding from live code -->
    """
  end

  defp country_details(%{country: nil} = assigns) do
    ~H"""
    <.alert id="no-countries" kind={:info} close={false}>
      No country found for the provided ID.
    </.alert>
    """
  end

  defp country_details(assigns) do
    ~H"""
    <div id="country" phx-update="replace">
      <.list class="mt-6 mb-16 ml-1">
        <:item title="Name"><%= @country.name %></:item>
        <:item title="Code"><%= @country.code %></:item>
        <:item title="Continent"><%= @country.continent %></:item>
        <:item title="Region"><%= @country.region %></:item>
        <:item title="The form of government"><%= @country.governmentform %></:item>
        <:item title="The year of independence"><%= @country.indepyear %></:item>
        <:item title="The head of state">
          <.editable id="headofstate" form={@form} edit={@edit_field == "headofstate"}>
            <%= @country.headofstate %>
            <:input_block>
              <.input field={@form[:headofstate]} type="text" class="flex-auto md:-ml-3" />
            </:input_block>
          </.editable>
        </:item>
        <:item title="Population">
          <.editable id="population" form={@form} edit={@edit_field == "population"}>
            <%= Number.Delimit.number_to_delimited(@country.population, precision: 0, delimiter: " ") %>
            <:input_block>
              <.input field={@form[:population]} type="number" step="any" class="flex-auto md:-ml-3" />
            </:input_block>
          </.editable>
        </:item>
        <:item title="GNP">
          <.editable id="gnp" form={@form} edit={@edit_field == "gnp"}>
            <%= Number.Delimit.number_to_delimited(@country.gnp, precision: 0, delimiter: " ") %>
            <:input_block>
              <.input field={@form[:gnp]} type="number" step="any" class="flex-auto md:-ml-3" />
            </:input_block>
          </.editable>
        </:item>
        <:item title="Life expectancy">
          <.editable id="lifeexpectancy" form={@form} edit={@edit_field == "lifeexpectancy"}>
            <%= Number.Delimit.number_to_delimited(@country.lifeexpectancy, precision: 2) %>
            <:input_block>
              <.input field={@form[:lifeexpectancy]} type="number" step="any" class="flex-auto md:-ml-3" />
            </:input_block>
          </.editable>
        </:item>
      </.list>
    </div>
    """
  end

  def handle_event("edit", %{"field" => field}, socket) do
    form =
      socket.assigns.country
      |> Countries.change_country()
      |> to_form()

    socket =
      assign(socket,
        edit_field: field,
        form: form
      )

    {:noreply, socket}
  end

  def handle_event("cancel", _, socket) do
    {:noreply, reset_edit_form(socket)}
  end

  def handle_event("save", %{"country" => params}, socket) do
    case Countries.update_country_broadcast(socket.assigns.country, params) do
      {:ok, _country} ->
        {:noreply, reset_edit_form(socket)}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def handle_info({:update_country, updated_country}, socket) do
    cond do
      updated_country.id == socket.assigns.country.id && socket.assigns.edit_field != nil ->
        # Notify the user about the update
        socket =
          socket
          |> assign(:country, updated_country)
          |> put_flash(:info, "This country's details have just been updated by another user.")

        {:noreply, socket}

      updated_country.id == socket.assigns.country.id ->
        {:noreply, assign(socket, country: updated_country)}

      true ->
        {:noreply, socket}
    end
  end

  defp reset_edit_form(socket) do
    assign(socket, edit_field: nil, form: nil)
  end
end
