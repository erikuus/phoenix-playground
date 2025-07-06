defmodule LivePlaygroundWeb.ErrorHTML do
  use LivePlaygroundWeb, :html

  # Embed the error templates
  embed_templates "error_html/*"

  # Fallback for any error codes that don't have custom templates
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
