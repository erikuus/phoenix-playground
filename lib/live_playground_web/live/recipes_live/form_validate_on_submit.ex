defmodule LivePlaygroundWeb.RecipesLive.FormValidateOnSubmit do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Cities
  alias LivePlayground.Cities.City

  @countrycode "EST"

  def mount(_params, _session, socket) do
    cities = Cities.list_country_city(@countrycode)
    form = get_empty_form()

    socket =
      socket
      |> assign(:cities, cities)
      |> assign(:form, form)

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
      Validate on Submit
      <:subtitle>
        Creating Forms That Validate on Submit in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.form for={@form} phx-submit="save" class="flex flex-col space-x-0 space-y-4 md:flex-row md:space-x-4 md:space-y-0">
      <.input field={@form[:name]} label="Name" class="flex-auto" />
      <.input field={@form[:district]} label="District" class="flex-auto" />
      <.input field={@form[:population]} label="Population" class="flex-auto" />
      <div>
        <.button phx-disable-with="" class="md:mt-8">Save</.button>
      </div>
    </.form>
    <.table :if={@cities != []} id="cities" rows={@cities}>
      <:col :let={city} label="Name">
        {city.name}
        <dl class="font-normal md:hidden">
          <dt class="sr-only">District</dt>
          <dd class="mt-1 truncate text-gray-700">{city.district}</dd>
        </dl>
      </:col>
      <:col :let={city} label="District" class="hidden md:table-cell">{city.district}</:col>
      <:col :let={city} label="Population" class="text-right">
        {Number.Delimit.number_to_delimited(city.population, precision: 0, delimiter: " ")}
      </:col>
    </.table>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/form_validate_on_submit.ex" />
      <.code_block filename="lib/live_playground/cities.ex" from="# form" to="# endform" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/form_validate_on_submit.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("save", %{"city" => params}, socket) do
    params = Map.put(params, "countrycode", @countrycode)

    case Cities.create_city(params) do
      {:ok, city} ->
        socket =
          socket
          |> update(:cities, &[city | &1])
          |> assign(:form, get_empty_form())
          |> put_flash(:info, "A new city has been added.")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end
end
