defmodule LivePlaygroundWeb.BroadcastLive do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    if connected?(socket), do: Countries.subscribe()

    socket =
      assign(socket,
        country: Countries.get_country!(228),
        edit_field: nil,
        form: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Real-Time Updates
      <:subtitle>
        How to broadcast real-time updates in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/broadcast-stream"}>
          See also: Real-Time Updates with Streams <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
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
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/broadcast_live.ex")) %>
      <%= raw(code("lib/live_playground/countries.ex", "# broadcast", "# endbroadcast")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("save", %{"country" => params}, socket) do
    case Countries.update_country_broadcast(socket.assigns.country, params) do
      {:ok, _country} ->
        socket =
          assign(socket,
            edit_field: nil,
            form: nil
          )

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
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
    socket =
      assign(socket,
        edit_field: nil,
        form: nil
      )

    {:noreply, socket}
  end

  def handle_info({:update_country, country}, socket) do
    {:noreply, assign(socket, country: country)}
  end
end
