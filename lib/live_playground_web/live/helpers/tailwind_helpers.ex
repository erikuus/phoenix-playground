defmodule LivePlaygroundWeb.Helpers.TailwindHelpers do
  def tw_button_classes(type \\ :primary, size \\ :md) do
    "
      inline-flex
      items-center
      border
      font-medium
      shadow-sm
      focus:outline-none
      focus:ring-2
      focus:ring-indigo-500
      focus:ring-offset-2
      #{get_button_type_classes(type)}
      #{get_button_size_classes(size)}
    "
  end

  defp get_button_type_classes(type) do
    Keyword.fetch!(
      [
        primary: "border-transparent text-white bg-indigo-600 hover:bg-indigo-700",
        secondary: "border-gray-300 text-gray-700 bg-white hover:bg-gray-50"
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

  def tw_modal_content_classes() do
    "
      relative
      transform
      overflow-hidden
      rounded-lg
      bg-white
      px-4
      pt-5
      pb-4
      text-left
      shadow-xl
      transition-all
      sm:my-8
      sm:w-full
      sm:max-w-sm sm:p-6
    "
  end
end
