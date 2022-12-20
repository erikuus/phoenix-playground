defmodule LivePlaygroundWeb.Helpers.LiveHelpers do
  import Phoenix.LiveView.Helpers

  alias LivePlaygroundWeb.Components

  def live_modal(component, opts, close_opts \\ %{capture_close: true, show_close_btn: false}) do
    live_component(
      Components.ModalComponent,
      id: :modal,
      component: component,
      opts: opts,
      return_to: Keyword.fetch!(opts, :return_to),
      close_opts: close_opts
    )
  end
end
