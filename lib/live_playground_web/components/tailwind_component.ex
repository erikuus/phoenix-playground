defmodule LivePlaygroundWeb.TailwindComponent do
  use LivePlaygroundWeb, :component

  attr :patch, :string
  attr :href, :string
  attr :color, :atom, default: :primary
  attr :size, :atom, default: :md
  attr :class, :string, default: nil
  attr :rest, :global

  def button(%{patch: patch} = assigns) do
    ~H"""
    <.link {@rest} patch={@patch} class={button_classes(@color, @size, @class)}}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def button(%{href: href} = assigns) do
    ~H"""
    <.link {@rest} href={@href} class={button_classes(@color, @size, @class)}}>
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
end
