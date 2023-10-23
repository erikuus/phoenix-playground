defmodule LivePlaygroundWeb.CompsLive.HeaderDemo do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {LivePlaygroundWeb.Layouts, :app}}
  end

  def render(assigns) do
    ~H"""
    <.header class="m-6">
      Title and subtitle
      <:subtitle>
        <%= placeholder_sentences(3) %>
      </:subtitle>
    </.header>

    <.header class="m-6">
      Title, subtitle and horizontal actions
      <:subtitle>
        <%= placeholder_sentences(3) %>
      </:subtitle>
      <:actions class="space-x-3">
        <.link>Action1</.link>
        <.link>Action2</.link>
      </:actions>
    </.header>

    <.header class="m-6">
      Title, subtitle and vertical actions
      <:subtitle>
        <%= placeholder_sentences(3) %>
      </:subtitle>
      <:actions class="flex-col space-y-2 xl:items-end">
        <.link>Action1</.link>
        <.link>Action2</.link>
      </:actions>
    </.header>
    """
  end
end
