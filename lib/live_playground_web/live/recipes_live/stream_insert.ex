defmodule LivePlaygroundWeb.RecipesLive.StreamInsert do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  @countrycode "EST"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:form, get_empty_form())
      |> stream_configure(:cities, dom_id: &"city-#{&1.countrycode}-#{&1.id}")
      |> stream(:cities, Cities.list_country_city(@countrycode))

    {:ok, socket}
  end

  defp get_empty_form() do
    %City{}
    |> Cities.change_city()
    |> to_form()
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Stream Insert
      <:subtitle>
        Inserting Items into Large Collections Without Server-Side Memory Storage in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-submit="save" class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0">
      <.input field={@form[:name]} label="Name" class="flex-auto" autocomplete="off" />
      <.input field={@form[:district]} label="District" class="flex-auto" autocomplete="off" />
      <.input field={@form[:population]} label="Population" class="flex-auto" autocomplete="off" />
      <div>
        <.button phx-disable-with="" class="md:mt-8">Save</.button>
      </div>
    </.form>
    <.table id="cities" rows={@streams.cities}>
      <:col :let={{_dom_id, city}} label="Name">
        {city.name}
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-zinc-700">{city.district}</dd>
        </dl>
        <dl class="hidden md:block font-normal text-xs text-zinc-400">
          <dt>Stream inserted:</dt>
          <dd>{Timex.now()}</dd>
        </dl>
      </:col>
      <:col :let={{_dom_id, city}} label="District" class="hidden md:table-cell">{city.district}</:col>
      <:col :let={{_dom_id, city}} label="Population" class="text-right md:pr-10">
        {Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ")}
      </:col>
      <:action :let={{dom_id, city}}>
        <.link phx-click={JS.push("delete", value: %{id: city.id}) |> hide("##{dom_id}")} data-confirm="Are you sure?">
          <span class="hidden md:inline">Delete</span>
          <.icon name="hero-trash-mini" class="md:hidden" />
        </.link>
      </:action>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/stream_insert.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# streaminsert" to="# endstreaminsert" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/stream_insert.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("save", %{"city" => params}, socket) do
    params = Map.put(params, "countrycode", @countrycode)

    case Cities.create_city(params) do
      {:ok, city} ->
        socket =
          socket
          |> assign(:form, get_empty_form())
          |> stream_insert(:cities, city, at: 0)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    city = Cities.get_city!(id)
    {:ok, _} = Cities.delete_city(city)

    {:noreply, stream_delete(socket, :cities, city)}
  end
end
