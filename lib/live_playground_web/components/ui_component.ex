defmodule LivePlaygroundWeb.UiComponent do
  use LivePlaygroundWeb, :component

  slot(:header)
  slot(:buttons)
  slot(:footer)
  slot(:inner_block, required: true)
  attr :class, :string, default: nil

  def heading(assigns) do
    ~H"""
    <div class="mb-6 md:flex md:items-center md:justify-between">
      <div class="min-w-0 flex-1">
        <%= render_slot(@header) %>
        <h2 class={heading_classes(@class)}><%= render_slot(@inner_block) %></h2>
        <%= render_slot(@footer) %>
      </div>
      <div class="mt-4 flex md:mt-0 md:ml-4">
        <%= render_slot(@buttons) %>
      </div>
    </div>
    """
  end

  defp heading_classes(class) do
    "text-2xl font-bold leading-7 sm:truncate sm:text-3xl sm:tracking-tight #{class}"
  end

  slot(:icon)
  slot(:inner_block, required: true)
  attr :title, :string
  attr :color, :atom, default: :info
  attr :class, :string, default: nil

  def alert(%{title: _title} = assigns) do
    ~H"""
    <div class={alert_classes(@color, @class)}>
      <div class="flex space-x-2">
        <%= render_slot(@icon) %>
        <div class="ml-1">
          <h3 class="text-sm font-medium"><%= @title %></h3>
          <div class="mt-1 text-sm opacity-75">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def alert(assigns) do
    ~H"""
    <div class={alert_classes(@color, @class)}>
      <div class="flex space-x-2">
        <%= render_slot(@icon) %>
        <div class="ml-1 text-sm">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  defp alert_classes(color, class) do
    "rounded-md p-4 #{alert_color_classes(color)} #{class}"
  end

  defp alert_color_classes(color) do
    Keyword.fetch!(
      [
        info: "bg-blue-50 text-blue-700",
        warning: "bg-yellow-50 text-yellow-700"
      ],
      color
    )
  end

  slot(:inner_block, required: true)
  attr :outer_event, :string, default: "close"
  attr :class, :string, default: nil

  def datalist(assigns) do
    ~H"""
    <div class="fixed inset-0" phx-capture-click={@outer_event}></div>
    <ul class={"absolute z-10 mt-1 overflow-auto rounded-md shadow-lg border border-gray-200 bg-white py-1 #{@class}"}>
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  slot(:inner_block, required: true)
  attr :class, :string, default: nil
  attr :rest, :global

  def option(assigns) do
    ~H"""
    <li {@rest} class={"relative cursor-default select-none hover:bg-indigo-700 hover:text-white py-2 pl-3 pr-9 #{@class}"} role="option">
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  slot(:inner_block, required: true)
  attr :class, :string, default: nil

  def ul(assigns) do
    ~H"""
    <div class={"overflow-hidden bg-white shadow-sm border border-gray-200 sm:rounded-md #{@class}"}>
      <ul role="list" class="divide-y divide-gray-200">
        <%= render_slot(@inner_block) %>
      </ul>
    </div>
    """
  end

  slot(:inner_block, required: true)
  attr :class, :string, default: nil

  def card(assigns) do
    ~H"""
    <div class={"overflow-hidden bg-white shadow-sm border border-gray-200 sm:rounded-md #{@class}"}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot(:inner_block, required: true)
  attr :class, :string, default: nil

  def statset(assigns) do
    ~H"""
    <dl class={"grid grid-cols-1 gap-5 sm:grid-cols-3 #{@class}"}>
      <%= render_slot(@inner_block) %>
    </dl>
    """
  end

  attr :class, :string, default: nil
  attr :label, :string, required: true
  attr :data, :string, required: true

  def stat(assigns) do
    ~H"""
    <div class={"relative overflow-hidden rounded-lg shadow-sm border border-gray-200 bg-white px-4 py-5 sm:p-6 #{@class}"}>
      <dt class="truncate text-sm font-medium text-gray-500"><%= @label %></dt>
      <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900"><%= render_slot(@inner_block) %></dd>
    </div>
    """
  end

  attr :patch, :string
  attr :href, :string
  attr :color, :atom, default: :primary
  attr :size, :atom, default: :md
  attr :class, :string, default: nil
  attr :rest, :global

  def button(%{patch: _patch} = assigns) do
    ~H"""
    <.link {@rest} patch={@patch} class={button_classes(@color, @size, @class)}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def button(%{href: _href} = assigns) do
    ~H"""
    <.link {@rest} href={@href} class={button_classes(@color, @size, @class)}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def button(assigns) do
    ~H"""
    <button {@rest} class={button_classes(@color, @size, @class)}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  defp button_classes(color, size, class) do
    "inline-flex items-center justify-center border font-medium shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 #{button_color_classes(color)} #{button_size_classes(size)} #{class}"
  end

  defp button_color_classes(color) do
    Keyword.fetch!(
      [
        primary:
          "border-transparent text-white bg-indigo-600 hover:bg-indigo-700 focus:ring-indigo-500",
        secondary:
          "border-gray-300 text-gray-700 bg-white hover:bg-gray-50 focus:ring-indigo-500",
        dangerous: "border-transparent text-white bg-red-600 hover:bg-red-700 focus:ring-red-500"
      ],
      color
    )
  end

  defp button_size_classes(size) do
    Keyword.fetch!(
      [
        xs: "rounded px-2.5 py-1.5 text-xs",
        sm: "rounded-md px-3 py-2 text-sm leading-4",
        md: "rounded-md px-4 py-2 text-sm",
        lg: "rounded-md px-4 py-2 text-base",
        xl: "rounded-md px-6 py-3 text-base"
      ],
      size
    )
  end

  attr :id, :string
  attr :label, :string
  attr :help, :string
  attr :hint, :string
  attr :class, :string, default: nil
  attr :rest, :global

  def input(%{id: _id, label: _label, help: _help} = assigns) do
    ~H"""
    <label for={@id} class={label_classes()}><%= @label %></label>
    <div class="mt-1">
      <input {@rest} id={@id} class={input_classes(@class)}>
    </div>
    <p class="mt-2 text-sm text-gray-500"><%= @help %></p>
    """
  end

  def input(%{id: _id, label: _label, hint: _hint} = assigns) do
    ~H"""
      <div class="flex justify-between">
        <label for={@id} class={label_classes()}><%= @label %></label>
        <span class="text-sm text-gray-500" id="email-optional"><%= @hint %></span>
      </div>
      <div class="mt-1">
        <input {@rest} id={@id} class={input_classes(@class)}>
      </div>
    """
  end

  def input(%{id: _id, label: _label} = assigns) do
    ~H"""
    <label for={@id} class={label_classes()}><%= @label %></label>
    <div class="mt-1">
      <input {@rest} id={@id} class={input_classes(@class)}>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <input {@rest} class={input_classes(@class)}>
    """
  end

  attr :id, :string
  attr :label, :string
  attr :help, :string
  attr :hint, :string
  attr :class, :string, default: nil
  attr :rest, :global

  def select(%{id: _id, label: _label, help: _help} = assigns) do
    ~H"""
    <label for={@id} class={label_classes()}><%= @label %></label>
    <div class="mt-1">
      <select {@rest} id={@id} class={input_classes(@class)}>
        <%= render_slot(@inner_block) %>
      </select>
    </div>
    <p class="mt-2 text-sm text-gray-500"><%= @help %></p>
    """
  end

  def select(%{id: _id, label: _label, hint: _hint} = assigns) do
    ~H"""
      <div class="flex justify-between">
        <label for={@id} class={label_classes()}><%= @label %></label>
        <span class="text-sm text-gray-500" id="email-optional"><%= @hint %></span>
      </div>
      <div class="mt-1">
        <select {@rest} id={@id} class={input_classes(@class)}>
          <%= render_slot(@inner_block) %>
        </select>
      </div>
    """
  end

  def select(%{id: _id, label: _label} = assigns) do
    ~H"""
    <label for={@id} class={label_classes()}><%= @label %></label>
    <div class="mt-1">
      <select {@rest} id={@id} class={input_classes(@class)}>
        <%= render_slot(@inner_block) %>
      </select>
    </div>
    """
  end

  def select(assigns) do
    ~H"""
    <select {@rest} class={input_classes(@class)}>
      <%= render_slot(@inner_block) %>
    </select>
    """
  end

  defp label_classes() do
    "block text-sm font-medium text-gray-700"
  end

  defp input_classes(class) do
    "block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm #{class}"
  end

  attr :id, :string
  attr :label, :string
  attr :label_on_right, :string
  attr :help, :string
  attr :value, :string, required: true
  attr :current, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def radio(%{id: _id, label: _label, help: _help} = assigns) do
    ~H"""
    <div class="relative flex items-start py-2">
      <div class="flex h-5 items-center">
        <input type="radio" {@rest} id={@id} value={@value} {get_checked(@value, @current)} class={radio_classes(@class)}>
      </div>
      <div class="ml-3 text-sm">
        <label for={@id} class="font-medium text-gray-700"><%= @label %></label>
        <p class="text-gray-500"><%= @help %></p>
      </div>
    </div>
    """
  end

  def radio(%{id: _id, label: _label} = assigns) do
    ~H"""
    <div class="flex items-center py-2">
      <input type="radio" {@rest} id={@id} value={@value} checked={get_checked(@value, @current)} class={radio_classes(@class)}>
      <label for={@id} class="ml-3 block text-sm font-medium text-gray-700"><%= @label %></label>
    </div>
    """
  end

  def radio(%{id: _id, label_on_right: _label, help: _help} = assigns) do
    ~H"""
    <div class="relative flex items-start py-2">
      <div class="min-w-0 flex-1 text-sm">
        <label for={@id} class="select-none font-medium text-gray-700"><%= @label_on_right %></label>
        <p class="text-gray-500"><%= @help %></p>
      </div>
      <div class="ml-3 flex h-5 items-center">
        <input type="radio" {@rest} id={@id} value={@value} {get_checked(@value, @current)} class={radio_classes(@class)}>
      </div>
    </div>
    """
  end

  def radio(%{id: _id, label_on_right: _label} = assigns) do
    ~H"""
    <div class="relative flex items-start py-2">
      <div class="min-w-0 flex-1 text-sm">
        <label for={@id} class="select-none font-medium text-gray-700"><%= @label_on_right %></label>
      </div>
      <div class="ml-3 flex h-5 items-center">
        <input type="radio" {@rest} id={@id} value={@value} {get_checked(@value, @current)} class={radio_classes(@class)}>
      </div>
    </div>
    """
  end

  def radio(assigns) do
    ~H"""
    <input type="radio" {@rest} value={@value} {get_checked(@value, @current)} class={radio_classes(@class)}>
    """
  end

  defp radio_classes(class) do
    "h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-500 #{class}"
  end

  defp get_checked(value, current) do
    if value == current, do: "checked"
  end

  attr :display, :atom, default: :block
  attr :class, :string, default: nil
  attr :legend, :string
  attr :help, :string

  def fieldset(%{display: :block, legend: _legend, help: _help} = assigns) do
    ~H"""
    <fieldset>
      <legend class="text-base font-medium text-gray-900"><%= @legend %></legend>
      <p class="text-sm leading-5 text-gray-500"><%= @help %></p>
      <div class={"mt-2 #{@class}"}>
        <%= render_slot(@inner_block) %>
      </div>
    </fieldset>
    """
  end

  def fieldset(%{display: :block, legend: _legend} = assigns) do
    ~H"""
    <fieldset>
      <legend class="text-base font-medium text-gray-900"><%= @legend %></legend>
      <div class={"mt-2 #{@class}"}>
        <%= render_slot(@inner_block) %>
      </div>
    </fieldset>
    """
  end

  def fieldset(%{display: :inline, legend: _legend, help: _help} = assigns) do
    ~H"""
    <fieldset>
      <legend class="text-base font-medium text-gray-900"><%= @legend %></legend>
      <p class="text-sm leading-5 text-gray-500"><%= @help %></p>
      <div class={"mt-2 sm:flex sm:items-center sm:space-y-0 sm:space-x-10 #{@class}"}>
        <%= render_slot(@inner_block) %>
      </div>
    </fieldset>
    """
  end

  def fieldset(%{display: :inline, legend: _legend} = assigns) do
    ~H"""
    <fieldset>
      <legend class="text-base font-medium text-gray-900"><%= @legend %></legend>
      <div class={"mt-2 space-y-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-10 #{@class}"}>
        <%= render_slot(@inner_block) %>
      </div>
    </fieldset>
    """
  end

  def fieldset(assigns) do
    ~H"""
    <%= render_slot(@inner_block) %>
    """
  end

  attr :type, :atom, required: true
  attr :opts, :map, required: true

  def confirm(%{type: :confirm_return} = assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-sm">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
        <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
        </svg>
      </div>
      <div class="mt-3 text-center sm:mt-5">
        <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title"><%= @opts.title %></h3>
        <div class="mt-2">
          <p class="text-sm text-gray-500"><%= @opts.description %></p>
        </div>
      </div>
      <div class="mt-5 sm:mt-6">
        <.button patch={@opts.return_to} class="w-full"><%= @opts.return_text %></.button>
      </div>
    </div>
    """
  end

  def confirm(%{type: :confirm_proceed} = assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-lg">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
        <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
        </svg>
      </div>
      <div class="mt-3 text-center sm:mt-5">
        <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title"><%= @opts.title %></h3>
        <div class="mt-2">
          <p class="text-sm text-gray-500"><%= @opts.description %></p>
        </div>
      </div>
      <div class="mt-5 sm:mt-6 sm:grid sm:grid-flow-row-dense sm:grid-cols-2 sm:gap-3">
        <.button patch={@opts.proceed_to} color={:primary} class="w-full"><%= @opts.proceed_text %></.button>
        <.button patch={@opts.return_to} color={:secondary} class="w-full mt-3 sm:mt-0"><%= @opts.return_text %></.button>
      </div>
    </div>
    """
  end

  def confirm(%{type: :confirm_action} = assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-lg">
      <div class="sm:flex sm:items-start">
        <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
          <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 10.5v3.75m-9.303 3.376C1.83 19.126 2.914 21 4.645 21h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 4.88c-.866-1.501-3.032-1.501-3.898 0L2.697 17.626zM12 17.25h.007v.008H12v-.008z" />
          </svg>
        </div>
        <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
          <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title"><%= @opts.title %></h3>
          <div class="mt-2">
            <p class="text-sm text-gray-500"><%= @opts.description %></p>
          </div>
        </div>
      </div>
      <div class="mt-5 sm:mt-4 sm:ml-10 sm:pl-4 sm:flex sm:flex-row-reverse">
        <.button patch={@opts.return_to} color={:secondary} class="w-full sm:w-auto"><%= @opts.return_text %></.button>
        <.button patch={@opts.action_to} color={:dangerous} class="w-full sm:w-auto mt-3 sm:mt-0 sm:mr-3"><%= @opts.action_text %></.button>
      </div>
    </div>
    """
  end
end
