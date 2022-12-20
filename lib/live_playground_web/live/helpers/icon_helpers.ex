defmodule LivePlaygroundWeb.Helpers.IconHelpers do
  def svg_icon_close(class) do
    """
      <svg class="#{class}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
      </svg>
    """
  end
end
