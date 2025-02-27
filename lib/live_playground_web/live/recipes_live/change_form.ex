defmodule LivePlaygroundWeb.RecipesLive.ChangeForm do
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
      Change Form
      <:subtitle>
        Handling Form Changes in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form id="dynamic-form" class="space-y-5" phx-change="refresh">
      <.input type="select" label="Color" name="color" options={color_options()} value={@color} />
      <%= render_dynamic_inputs(:color, assigns) %>
      <div class="ml-1 space-y-2">
        <.input type="radio" name="shape" label="Circle" id="circle" value="circle" checked={@shape == "circle"} />
        <.input type="radio" name="shape" label="Rectangle" id="rectangle" value="rectangle" checked={@shape == "rectangle"} />
        <%= render_dynamic_inputs(:rectangle, assigns) %>
        <.input type="radio" name="shape" label="Square" id="square" value="square" checked={@shape == "square"} />
        <%= render_dynamic_inputs(:square, assigns) %>
      </div>
    </form>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/recipes_live/change_form.ex" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/change_form.html" />
    <!-- end hiding from live code -->
    """
  end

  defp render_dynamic_inputs(:color, %{color: "green"} = assigns) do
    ~H"""
    <div id="greens" phx-update="ignore" class="space-y-5 ml-6">
      <.input type="text" id="dark-green" label="Dark Green" name="dark_green" value="" />
      <.input type="text" id="light-green" label="Light Green" name="light_green" value="" />
    </div>
    """
  end

  defp render_dynamic_inputs(:color, %{color: "blue"} = assigns) do
    ~H"""
    <div id="blues" phx-update="ignore" class="space-y-5 ml-6">
      <.input type="text" id="dark-blue" label="Dark Blue" name="dark_blue" value="" />
      <.input type="text" id="light-blue" label="Light Blue" name="light_blue" value="" />
    </div>
    """
  end

  defp render_dynamic_inputs(:rectangle, %{shape: "rectangle"} = assigns) do
    ~H"""
    <div id="rectangles" phx-update="ignore" class="mt-2 ml-6 space-y-2">
      <.input type="radio" name="rectangle" id="a" label="A" value="a" checked={true} />
      <.input type="radio" name="rectangle" id="b" label="B" value="b" checked={false} />
    </div>
    """
  end

  defp render_dynamic_inputs(:square, %{shape: "square"} = assigns) do
    ~H"""
    <div id="squares" phx-update="ignore" class="mt-2 ml-6 space-y-2">
      <.input type="radio" name="square" id="c" label="C" value="c" checked={true} />
      <.input type="radio" name="square" id="d" label="D" value="d" checked={false} />
    </div>
    """
  end

  defp render_dynamic_inputs(_, _), do: nil

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
