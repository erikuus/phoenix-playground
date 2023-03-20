defmodule LivePlaygroundWeb.MoreComponents do
  @moduledoc """
  Provides UI components in addition to core components.

  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.
  """
  use Phoenix.Component

  @doc """
  Renders an alert box.

  ## Examples

      <.alert>Info</.alert>
      <.alert type="warning">Warning</.alert>
      <.alert type="error">Error</.alert>
  """
  attr :type, :string, default: "info"
  attr :class, :string, default: "text-sm"

  slot :inner_block, required: true

  def alert(assigns) do
    ~H"""
    <div class={["rounded-md p-4", alert_color_class(@type), @class]}>
      <div class="flex space-x-2">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp alert_color_class(type) do
    Map.get(
      %{
        "info" => "bg-blue-50 text-blue-700",
        "warning" => "bg-yellow-50 text-yellow-700",
        "error" => "bg-red-50 text-red-700"
      },
      type
    )
  end

  @doc """
  Renders a link styled as button.

  ## Examples

      <.button_link navigate={~p"/page"}>Go</.button_link>
      <.button_link patch={~p"/page"} type="secondary">Refresh</.button_link>
  """
  attr :type, :string, default: "primary"
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch)

  slot :inner_block, required: true

  def button_link(assigns) do
    ~H"""
    <.link
      class={[
        "inline-flex items-center justify-center rounded-lg py-2 px-5",
        "text-sm font-semibold leading-6",
        button_color_class(@type),
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp button_color_class(type) do
    Map.get(
      %{
        "primary" => "bg-zinc-700 hover:bg-zinc-900 text-white active:text-white/80",
        "secondary" =>
          "border border-zinc-200 bg-zinc-100 hover:bg-zinc-200 text-gray-700 active:text-gray-800",
        "dangerous" => "bg-red-600 hover:bg-red-700 text-white active:text-white/80"
      },
      type
    )
  end

  @doc """
  Renders a basic card.

  ## Examples

      <.card>Content</.card>
      <.card class="mt-6">Content</.card>
  """
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={["overflow-hidden bg-white shadow-sm border border-gray-200 rounded-md", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a simple data list.

  ## Examples

      <.simple_list :if={@items != []}>
        <:item :for={item <- @items}><%= item.name %></:item>
      </.simple_list>
  """
  attr :class, :string, default: nil

  slot :item, required: true do
    attr :class, :string
  end

  def simple_list(assigns) do
    ~H"""
    <div class={@class}>
      <dl class="divide-y divide-zinc-100">
        <div :for={item <- @item} class={["flex gap-4 py-4 sm:gap-8", Map.get(item, :class)]}>
          <%= render_slot(item) %>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders tabs.

  ## Examples

      <.tabs>
        <:item :for={item <- @items} patch={~p"/route?#{}"}><%= item.name %></:item>
      </.tabs>
  """
  attr :class, :string, default: nil

  slot :item, required: true do
    attr :patch, :any, required: true
    attr :active, :boolean
  end

  def tabs(assigns) do
    ~H"""
    <div class="border-b border-gray-200">
      <nav class="-mb-px flex space-x-8">
        <.link :for={item <- @item} patch={item[:patch]} class={tab_class(item[:active])}>
          <%= render_slot(item) %>
        </.link>
      </nav>
    </div>
    """
  end

  defp tab_class(false) do
    "border-transparent text-zinc-400 hover:border-zinc-300 whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium"
  end

  defp tab_class(true) do
    "border-zinc-500 text-zinc-600 whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium"
  end

  @doc """
  Renders a data list.

  ## Examples

      <.stat>
        <:item title="Orders">
          <%= @orders %>
        </:item>
        <:item title="Amount">
          <%= @amount %>
        </:item>
        <:item title="Satisfaction">
          <%= @satisfaction %>
        </:item>
      </.stat>
  """
  attr :class, :string, default: nil

  slot :item, required: true do
    attr :title, :string, required: true
  end

  def stat(assigns) do
    ~H"""
    <dl class={["grid grid-cols-1 gap-5 sm:grid-cols-3", @class]}>
      <div :for={item <- @item} class="relative overflow-hidden rounded-lg shadow-sm border border-gray-200 bg-white px-4 py-5 sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500"><%= item.title %></dt>
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">
          <%= render_slot(item) %>
        </dd>
      </div>
    </dl>
    """
  end

  @doc """
  Renders a dropdown area.

  ## Examples

      <.dropdown :if={@open} class="max-h-64 w-96">
        ...
      </.dropdown>
  """
  attr :outer_event, :string, default: "close"
  attr :class, :string, default: nil

  slot :inner_block, required: true

  def dropdown(assigns) do
    ~H"""
    <div class="fixed inset-0" phx-capture-click={@outer_event}></div>
    <ul class={"absolute z-10 mt-1 overflow-auto rounded-md shadow-lg border border-gray-200 bg-white py-1 #{@class}"}>
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  @doc """
  Renders a dropdown option.

  ## Examples

      <.dropdown :if={@open} class="max-h-64 w-96">
        <.option :for={item <- @items} phx-click="select" phx-value-id={item.id}>
          <%= item.name %>
        </.option>
      </.dropdown>
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def option(assigns) do
    ~H"""
    <li {@rest} class={"relative cursor-default select-none hover:bg-zinc-700 hover:text-white py-2 pl-3 pr-9 #{@class}"}>
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  @doc """
  Renders a spinning circle as a loading indicator.

  ## Examples

      <.loading :if={@loading} />
      <button type="submit">
        Search <.loading :if={@loading} class="ml-2 -mr-2 w-5 h-5" />
      </button>
  """
  attr :class, :string, default: "w-6 h-6"

  def loading(assigns) do
    ~H"""
    <svg class={["animate-spin", @class]} xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      >
      </path>
    </svg>
    """
  end
end
