defmodule LivePlaygroundWeb.Components.ImageComponent do
  use LivePlaygroundWeb, :live_component

  def mount(socket) do
    socket =
      assign(socket,
        images: [],
        current: 0,
        playing: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6 mx-auto max-w-4xl">
      <h1 class="text-2xl font-bold leading-7">
        <%= @title %>
      </h1>
      <div class="my-6 space-y-3">
        <img src={"/images/#{Enum.at(@images, @current)}"} class="w-full" />
      </div>
      <div class="flex flex-col space-y-3 lg:flex-row lg:space-y-0">
        <.button_link patch={@return_to} type="secondary"><%= @return_text %></.button_link>
      </div>
    </div>
    """
  end
end
