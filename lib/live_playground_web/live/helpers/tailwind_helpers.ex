defmodule LivePlaygroundWeb.Helpers.TailwindHelpers do
  def tw_button_classes(size \\ :md) do
    "
      inline-flex
      items-center
      border
      border-gray-300
      bg-white
      font-medium
      text-gray-700
      shadow-sm
      hover:bg-gray-50
      focus:outline-none
      focus:ring-2
      focus:ring-indigo-500
      focus:ring-offset-2
      #{get_button_size_classes(size)}
    "
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
