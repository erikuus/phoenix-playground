defmodule LivePlaygroundWeb.Components.TextComponent do
  use LivePlaygroundWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="p-6 sm:max-w-6xl">
      <h1 class="text-2xl font-bold leading-7">
        <%= @heading %>
      </h1>
      <div class="mt-6 space-y-3">
        <%= @content %>
      </div>
    </div>
    """
  end
end
