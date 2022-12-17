defmodule LivePlaygroundWeb.Helpers.LiveHelpers do
  import Phoenix.LiveView.Helpers

  alias LivePlaygroundWeb.Components

  def live_modal(component, opts) do
    live_component(
      Components.ModalComponent,
      id: :modal,
      component: component,
      opts: opts,
      return_to: Keyword.fetch!(opts, :return_to)
    )
  end
end
