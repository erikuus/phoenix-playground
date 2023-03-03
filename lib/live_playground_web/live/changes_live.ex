defmodule LivePlaygroundWeb.ChangesLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        color: "red",
        shape: "circle"
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.heading>
      Changes
      <:footer>
        How to handle form changes in live view
      </:footer>
    </.heading>
    <!-- end hiding from live code -->
    <form id="dynamic-form" class="space-y-5" phx-change="refresh">
      <div>
        <.select id="color" label="Color" name="color">
          <%= options_for_select(color_options(), @color) %>
        </.select>
      </div>
      <%= render_partial(:color, @color, assigns) %>
      <div>
        <.fieldset legend="Shapes">
          <.radio name="shape" value="circle" id="circle" label="Circle" checked={@shape == "circle"} />
          <.radio name="shape" value="rectangle" id="rectangle" label="Rectangle" checked={@shape == "rectangle"} />
          <%= render_partial(:rectangle, @shape, assigns) %>
          <.radio name="shape" value="square" id="square" label="Square" checked={@shape == "square"} />
          <%= render_partial(:square, @shape, assigns) %>
        </.fieldset>
      </div>
    </form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/changes_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp render_partial(:color, "green", assigns) do
    ~H"""
    <div id="greens" phx-update="ignore" class="space-y-5 ml-6">
      <div>
        <.input id="dark-green" label="Dark Green" name="dark_green" type="text" />
      </div>
      <div>
        <.input id="light-green" label="Light Green" name="light_green" type="text" />
      </div>
    </div>
    """
  end

  defp render_partial(:color, "blue", assigns) do
    ~H"""
    <div id="blues" phx-update="ignore" class="space-y-5 ml-6">
      <div>
        <.input id="dark-blue" label="Dark Blue" name="dark_blue" type="text" />
      </div>
      <div>
        <.input id="light-blue" label="Light Blue" name="light_blue" type="text" />
      </div>
    </div>
    """
  end

  defp render_partial(:rectangle, "rectangle", assigns) do
    ~H"""
    <div id="rectangles" phx-update="ignore" class="ml-6">
      <.radio id="a" label="A" name="rectangles" value="1" />
      <.radio id="b" label="B" name="rectangles" value="2" />
    </div>
    """
  end

  defp render_partial(:square, "square", assigns) do
    ~H"""
    <div id="squares" phx-update="ignore" class="ml-6">
      <.radio id="c" label="C" name="squares" value="3" />
      <.radio id="d" label="D" name="squares" value="4" />
    </div>
    """
  end

  defp render_partial(_, _, _), do: nil

  def handle_event("refresh", %{"color" => color, "shape" => shape}, socket) do
    socket =
      assign(socket,
        color: color,
        shape: shape
      )

    {:noreply, socket}
  end

  defp color_options do
    [
      Red: "red",
      Green: "green",
      Blue: "blue"
    ]
  end
end
