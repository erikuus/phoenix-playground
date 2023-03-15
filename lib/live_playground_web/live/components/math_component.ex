defmodule LivePlaygroundWeb.Components.MathComponent do
  use LivePlaygroundWeb, :live_component

  def mount(socket) do
    {:ok, assign(socket, :value, 0)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold leading-7 mb-6">
        <%= @title %>
      </h1>
      <form phx-submit="add" phx-target={@myself}>
        <div class="mb-3 font-bold">Current value is <%= @value %></div>
        <.input type="text" label="Value to add" name="add" autocomplete="off" value="" />
        <div class="flex flex-col space-y-3 lg:flex-row-reverse lg:space-y-0 mt-3">
          <.button_link patch={@proceed_to} type="secondary"><%= @proceed_text %></.button_link>
          <.button type="submit" class="mr-3">Add</.button>
        </div>
      </form>
    </div>
    """
  end

  def handle_event("add", %{"add" => add}, socket) do
    add = to_integer(add, 0)
    socket = update(socket, :value, &(&1 + add))
    {:noreply, socket}
  end

  defp to_integer(nil, default_value), do: default_value

  defp to_integer(value, default_value) do
    case Integer.parse(value) do
      {i, _} -> i
      :error -> default_value
    end
  end
end
