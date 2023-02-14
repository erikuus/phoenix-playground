defmodule LivePlaygroundWeb.AutocompleteLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :matches, [])}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.heading>
      Autocomplete
      <:footer>
      How to handle autocomplete in live view
      </:footer>
    </.heading>
    <!-- end hiding from live code -->
    <form phx-change="suggest">
      <.input
        phx-debounce="1000"
        type="text"
        name="query"
        list="matches"
        autocomplete="off"
        placeholder="Country"
        class="w-96" />
    </form>
    <datalist id="matches">
      <option :for={match <- @matches} value={match.name} />
    </datalist>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/autocomplete_live.ex")) %>
      <%= raw(code("lib/live_playground/countries.ex", "# search", "# endsearch")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    {:noreply, assign(socket, :matches, Countries.list_country(query))}
  end
end
