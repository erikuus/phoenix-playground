defmodule LivePlaygroundWeb.TailwindHelpers do
  def tw_label_classes() do
    "
      block
      text-sm
      font-medium
      text-gray-700
    "
  end

  def tw_input_classes() do
    "
      block w-full
      rounded-md
      border-gray-300
      shadow-sm
      focus:border-indigo-500
      focus:ring-indigo-500 sm:text-sm
    "
  end

  def tw_radio_classes() do
    "
      h-4
      w-4
      mr-3
      border-gray-300
      text-indigo-600
      focus:ring-indigo-500
    "
  end

  def tw_button_classes(type \\ :primary, size \\ :md) do
    "
      inline-flex
      items-center
      justify-center
      border
      font-medium
      shadow-sm
      focus:outline-none
      focus:ring-2
      focus:ring-offset-2
      #{get_button_type_classes(type)}
      #{get_button_size_classes(size)}
    "
  end

  defp get_button_type_classes(type) do
    Keyword.fetch!(
      [
        primary: "
          border-transparent
          text-white
          bg-indigo-600
          hover:bg-indigo-700
          focus:ring-indigo-500
        ",
        secondary: "
          border-gray-300
          text-gray-700
          bg-white
          hover:bg-gray-50
          focus:ring-indigo-500
        ",
        dangerous: "
          border-transparent
          text-white
          bg-red-600
          hover:bg-red-700
          focus:ring-red-500
        "
      ],
      type
    )
  end

  defp get_button_size_classes(size) do
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
end
