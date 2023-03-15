defmodule LivePlaygroundWeb.Components.TextComponent do
  use LivePlaygroundWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :content, nil)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6 mx-auto max-w-5xl">
      <h1 class="text-2xl font-bold leading-7">
        <%= @title %>
      </h1>
      <div class="my-6 space-y-3">
        <%= @content %>
      </div>
      <div class="flex flex-col space-y-3 lg:flex-row-reverse lg:space-y-0">
        <.button_link patch={@proceed_to} type="secondary"><%= @proceed_text %></.button_link>
        <.button phx-click="reload" phx-target={@myself} class="lg:mr-3">Reload random paragraphs</.button>
      </div>
    </div>
    """
  end

  def handle_event("reload", _, socket) do
    {:noreply, assign(socket, :content, lorem_ipsum_paragraphs(3, true))}
  end
end
