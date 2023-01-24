defmodule LivePlaygroundWeb.UiComponent do
  use LivePlaygroundWeb, :component

  slot(:header)
  slot(:buttons)
  slot(:footer)
  slot(:inner_block, required: true)
  attr :class, :string, default: nil

  def heading(assigns) do
    ~H"""
    <div class="md:flex md:items-center md:justify-between">
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

  def heading_classes(class \\ nil) do
    "text-2xl font-bold leading-7 sm:truncate sm:text-3xl sm:tracking-tight #{class}"
  end

  attr :patch, :string
  attr :href, :string
  attr :color, :atom, default: :primary
  attr :size, :atom, default: :md
  attr :class, :string, default: nil
  attr :rest, :global

  def button(%{patch: patch} = assigns) do
    ~H"""
    <.link {@rest} patch={@patch} class={button_classes(@color, @size, @class)}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def button(%{href: href} = assigns) do
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

  def button_classes(color \\ :primary, size \\ :md, class \\ nil) do
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

  def input(%{id: id, label: label, help: help} = assigns) do
    ~H"""
    <label for={@id} class={label_classes()}><%= @label %></label>
    <div class="mt-1">
      <input {@rest} id={@id} class={input_classes(@class)}>
    </div>
    <p class="mt-2 text-sm text-gray-500"><%= @help %></p>
    """
  end

  def input(%{id: id, label: label, hint: hint} = assigns) do
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

  def input(%{id: id, label: label} = assigns) do
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

  def select(%{id: id, label: label, help: help} = assigns) do
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

  def select(%{id: id, label: label, help: help} = assigns) do
    ~H"""
    <label for={@id} class={label_classes()}><%= @label %></label>
    <div class="mt-1">
      <select {@rest} id={@id} class={input_classes(@class)}>
      </select>
    </div>
    <p class="mt-2 text-sm text-gray-500"><%= @help %></p>
    """
  end

  def select(%{id: id, label: label, hint: hint} = assigns) do
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

  def select(%{id: id, label: label} = assigns) do
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

  def input_classes(class \\ nil) do
    "block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm #{class}"
  end

  def label_classes(class \\ nil) do
    "block text-sm font-medium text-gray-700 #{class}"
  end

  attr :id, :string
  attr :label, :string
  attr :label_on_right, :string
  attr :help, :string
  attr :value, :string, required: true
  attr :current, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def radio(%{id: id, label: label, help: help} = assigns) do
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

  def radio(%{id: id, label: label} = assigns) do
    ~H"""
    <div class="flex items-center py-2">
      <input type="radio" {@rest} id={@id} value={@value} checked={get_checked(@value, @current)} class={radio_classes(@class)}>
      <label for={@id} class="ml-3 block text-sm font-medium text-gray-700"><%= @label %></label>
    </div>
    """
  end

  def radio(%{id: id, label_on_right: label, help: help} = assigns) do
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

  def radio(%{id: id, label_on_right: label} = assigns) do
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

  def radio_classes(class \\ nil) do
    "h-4 w-4 border-gray-300 text-indigo-600 focus:ring-indigo-500 #{class}"
  end

  defp get_checked(value, current) do
    if value == current, do: "checked"
  end

  attr :display, :atom, default: :block
  attr :class, :string, default: nil
  attr :legend, :string
  attr :help, :string

  def fieldset(%{display: :block, legend: legend, help: help} = assigns) do
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

  def fieldset(%{display: :block, legend: legend} = assigns) do
    ~H"""
    <fieldset>
      <legend class="text-base font-medium text-gray-900"><%= @legend %></legend>
      <div class={"mt-2 #{@class}"}>
        <%= render_slot(@inner_block) %>
      </div>
    </fieldset>
    """
  end

  def fieldset(%{display: :inline, legend: legend, help: help} = assigns) do
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

  def fieldset(%{display: :inline, legend: legend} = assigns) do
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

  attr :title, :string, required: true
  attr :description, :string, required: true
  attr :go_text, :string, default: "OK"
  attr :return_text, :string, default: "Cancel"
  attr :go_to, :string
  attr :return_to, :string

  def confirm(assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-sm">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
        <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
        </svg>
      </div>
      <div class="mt-3 text-center sm:mt-5">
        <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title"><%= @title %></h3>
        <div class="mt-2">
          <p class="text-sm text-gray-500"><%= @description %></p>
        </div>
      </div>
      <div class="mt-5 sm:mt-6">
        <.button patch={@return_to} class="w-full"><%= @return_text %></.button>
      </div>
    </div>
    """
  end
end
