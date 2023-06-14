defmodule LivePlaygroundWeb.DynamicFormLive do
  use LivePlaygroundWeb, :live_view

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
    <.header class="mb-6">
      Dynamic Form
      <:subtitle>
        How to handle form changes in LiveView
      </:subtitle>
    </.header>
    <!-- end hiding from live code -->
    <form id="dynamic-form" class="space-y-5" phx-change="refresh">
      <.input type="select" label="Color" name="color" options={color_options()} value={@color} />
      <%= render_partial(:color, @color, assigns) %>
      <div class="ml-1 space-y-2">
        <.input type="radio" name="shape" label="Circle" id="circle" value="circle" checked={@shape == "circle"} />
        <.input type="radio" name="shape" label="Rectangle" id="rectangle" value="rectangle" checked={@shape == "rectangle"} />
        <%= render_partial(:rectangle, @shape, assigns) %>
        <.input type="radio" name="shape" label="Square" id="square" value="square" checked={@shape == "square"} />
        <%= render_partial(:square, @shape, assigns) %>
      </div>
    </form>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/dynamic_form_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  defp render_partial(:color, "green", assigns) do
    ~H"""
    <div id="greens" phx-update="ignore" class="space-y-5 ml-6">
      <.input type="text" id="dark-green" label="Dark Green" name="dark_green" value="" />
      <.input type="text" id="light-green" label="Light Green" name="light_green" value="" />
    </div>
    """
  end

  defp render_partial(:color, "blue", assigns) do
    ~H"""
    <div id="blues" phx-update="ignore" class="space-y-5 ml-6">
      <.input type="text" id="dark-blue" label="Dark Blue" name="dark_blue" value="" />
      <.input type="text" id="light-blue" label="Light Blue" name="light_blue" value="" />
    </div>
    """
  end

  defp render_partial(:rectangle, "rectangle", assigns) do
    ~H"""
    <div id="rectangles" phx-update="ignore" class="mt-2 ml-6 space-y-2">
      <.input type="radio" name="rectangle" id="a" label="A" value="a" checked={true} />
      <.input type="radio" name="rectangle" id="b" label="B" value="b" checked={false} />
    </div>
    """
  end

  defp render_partial(:square, "square", assigns) do
    ~H"""
    <div id="squares" phx-update="ignore" class="mt-2 ml-6 space-y-2">
      <.input type="radio" name="square" id="c" label="C" value="c" checked={true} />
      <.input type="radio" name="square" id="d" label="D" value="d" checked={false} />
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
