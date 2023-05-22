defmodule LivePlaygroundWeb.MoreComponents do
  @moduledoc """
  Provides UI components in addition to core components.

  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.
  """
  use Phoenix.Component

  import LivePlaygroundWeb.CoreComponents

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
        "primary" => "bg-zinc-900 hover:bg-zinc-700 text-white active:text-white/80",
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
        <:tab :for={tab <- @tabs} patch={~p"/route?#{}"} active={tab == @tab}><%= tab.name %></:tab>
      </.tabs>
  """
  attr :class, :string, default: nil

  slot :tab, required: true do
    attr :patch, :any, required: true
    attr :active, :boolean
  end

  def tabs(assigns) do
    ~H"""
    <div class={["border-b border-gray-200", @class]}>
      <nav class="-mb-px flex space-x-8 flex-wrap md:flex-nowrap">
        <.link
          :for={tab <- @tab}
          patch={tab[:patch]}
          class={[
            "whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium",
            tab_class(tab[:active])
          ]}
        >
          <%= render_slot(tab) %>
        </.link>
      </nav>
    </div>
    """
  end

  defp tab_class(false) do
    "border-transparent text-zinc-400 hover:border-zinc-300"
  end

  defp tab_class(true) do
    "border-zinc-500 text-zinc-600"
  end

  @doc """
  Renders pagination container.

  ## Examples

    <.pages>
      <:prev_icon><.icon name="hero-arrow-long-left" class="mr-3 h-5 w-5 text-gray-400" /></:prev_icon>
      <:prev :if={@page > 1} patch={~p"/demo?\#{[page: @page - 1]]}"}>Previous</:prev>
      <:page :for={page <- get_pages(@options, @count)} patch={~p"/demo?\#{[page: @page]]}"} active={@page == page}>
        <%= page %>
      </:page>
      <:next :if={@page * @per_page < @count} patch={~p"/demo?\#{[page: @page + 1]]}"}>Next</:next>
      <:next_icon><.icon name="hero-arrow-long-right" class="ml-3 h-5 w-5 text-gray-400" /></:next_icon>
    </.pages>
  """
  attr :class, :string, default: nil

  slot :prev
  slot :next
  slot :pages

  def pagination(assigns) do
    ~H"""
    <nav class={["flex items-center justify-between border-t border-gray-200 px-4 sm:px-0", @class]}>
      <div class="-mt-px flex w-0 flex-1">
        <%= render_slot(@prev) %>
      </div>
      <div class="hidden lg:-mt-px lg:flex">
        <%= render_slot(@pages) %>
      </div>
      <div class="-mt-px flex w-0 flex-1 justify-end">
        <%= render_slot(@next) %>
      </div>
    </nav>
    """
  end

  @doc """
  Renders pagination link.
  """
  attr :type, :string, default: "page"
  attr :active, :boolean, default: false
  attr :patch, :any
  attr :event, :string
  attr :page, :integer

  slot :inner_block, required: true

  def page_link(%{patch: _} = assigns) do
    ~H"""
    <.link patch={@patch} class={[page_class(:base), page_class(@type), page_class(@active)]}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def page_link(%{event: _, page: _} = assigns) do
    ~H"""
    <.link phx-click={@event} phx-value-page={@page} class={[page_class(:base), page_class(@type), page_class(@active)]}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def page_link(_assigns), do: nil

  defp page_class(:base) do
    "inline-flex items-center border-t-2 pt-4 text-sm font-medium"
  end

  defp page_class(false) do
    "border-transparent text-zinc-400 hover:border-zinc-300"
  end

  defp page_class(true) do
    "border-zinc-500 text-zinc-600"
  end

  defp page_class("prev"), do: "pr-4"

  defp page_class("page"), do: "px-4"

  defp page_class("next"), do: "pl-4"

  @doc """
  Renders a data list.

  ## Examples

      <.stat>
        <:card title="Orders">
          <%= @orders %>
        </:card>
        <:card title="Amount">
          <%= @amount %>
        </:card>
        <:card title="Satisfaction">
          <%= @satisfaction %>
        </:card>
      </.stat>
  """
  attr :class, :string, default: nil

  slot :card, required: true do
    attr :title, :string, required: true
  end

  def stat(assigns) do
    ~H"""
    <dl class={["grid grid-cols-1 gap-5 sm:grid-cols-3", @class]}>
      <div :for={card <- @card} class="relative overflow-hidden rounded-lg shadow-sm border border-gray-200 bg-white px-4 py-5 sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500"><%= card.title %></dt>

        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">
          <%= render_slot(card) %>
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
        <.option :for={option <- @options} phx-click="select" phx-value-id={option.id}>
          <%= option.name %>
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

  @doc """
  Renders an editable content.

  Editable field has two blocks: (1) inner block content with edit link
  and (2) input field(s) block with save and cancel buttons. Edit link,
  save and cancel buttons are pointing to events that must be defined in
  liveview that renders this component.

  ## Examples

      <div id="country" phx-update="replace">
        <.list class="mt-6 mb-16 ml-1">
          <:item title="Name"><%= @user.name %></:item>
          <:item title="Email">
            <.editable id="email" form={@form} edit={@edit_field == "email"}>
              <%= @user.email %>
              <:input_block>
                <.input field={@form[:email]} type="email" />
              </:input_block>
            </.editable>
          </:item>
        </.list>
      </div>
  """
  attr :id, :string, required: true
  attr :form, :map, required: true
  attr :edit, :boolean, required: true
  attr :save_event, :string, default: "save"
  attr :edit_event, :string, default: "edit"
  attr :cancel_event, :string, default: "cancel"

  slot :inner_block, required: true
  slot :input_block, required: true

  def editable(assigns) do
    ~H"""
    <div :if={!@edit} class="w-full flex items-center justify-between">
      <div id={@id}>
        <%= render_slot(@inner_block) %>
      </div>
      <.link phx-click={@edit_event} phx-value-field={@id}>
        <span class="hidden md:inline font-bold">Edit</span>
        <.icon name="hero-pencil-square-mini" class="md:hidden h-6 w-6" />
      </.link>
    </div>
    <.form
      :if={@edit}
      for={@form}
      phx-submit={@save_event}
      class="flex flex-col space-x-0 space-y-2 md:flex-row md:space-x-2 md:space-y-0"
    >
      <%= render_slot(@input_block) %>
      <div>
        <.button class="w-full md:w-auto" phx-disable-with="">Save</.button>
      </div>
      <div>
        <.button_link type="secondary" class="w-full md:w-auto" phx-click={@cancel_event}>Cancel</.button_link>
      </div>
    </.form>
    """
  end
end
