defmodule LivePlaygroundWeb.JsCommandsLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :btn, nil)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      JS Commands
      <:subtitle>
        How to toggle slideover panel with javascript commands in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/js-commands-form"}>
          See also: Dynamic Form with JS Commands <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button phx-click={show_panel()}>
      Show
    </.button>
    <.alert :if={@btn} class="mt-6">
      <%= @btn %> clicked!
    </.alert>
    <div class="relative z-50" aria-labelledby="slide-over-title" role="dialog" aria-modal="true">
      <div id="panel-bg" class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity hidden" />
      <div id="panel" class="fixed inset-0 overflow-hidden hidden">
        <div class="absolute inset-0 overflow-hidden">
          <div class="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10">
            <div class="pointer-events-auto w-screen max-w-md">
              <.focus_wrap
                id="#panel-container"
                phx-window-keydown={hide_panel()}
                phx-key="escape"
                phx-click-away={hide_panel()}
                class="flex h-full flex-col bg-white py-6 shadow-xl px-4 sm:px-6"
              >
                <div class="flex items-center justify-between">
                  <h2 class="text-base font-semibold leading-6 text-gray-900" id="slide-over-title">Panel title</h2>
                  <div class="ml-3 flex h-7">
                    <button phx-click={hide_panel()} type="button">
                      <.icon name="hero-x-mark" class="h-6 w-6" />
                    </button>
                  </div>
                </div>
                <div class="relative mt-6 flex-1 overflow-y-auto">
                  Panel content
                </div>
                <div class="border-t border-zinc-200 pt-4 sm:pl-4 sm:flex sm:flex-row-reverse">
                  <.link
                    phx-click={hide_panel()}
                    class={[
                      "inline-flex items-center justify-center rounded-lg border border-zinc-200 bg-zinc-100 hover:bg-zinc-200",
                      "py-2 px-5 text-sm font-semibold leading-6 text-gray-700 active:text-gray-800",
                      "w-full sm:w-auto sm:ml-3"
                    ]}
                  >
                    Cancel
                  </.link>
                  <.button phx-click={JS.push("confirm", value: %{btn: "OK"}) |> hide_panel()} class="w-full sm:w-auto mt-3 sm:mt-0">
                    OK
                  </.button>
                </div>
              </.focus_wrap>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/js_commands_live.ex")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("confirm", %{"btn" => btn}, socket) do
    Process.send_after(self(), :reset, 2000)
    {:noreply, assign(socket, :btn, btn)}
  end

  def handle_info(:reset, socket) do
    {:noreply, assign(socket, :btn, nil)}
  end

  defp show_panel(js \\ %JS{}) do
    js
    |> JS.show(
      to: "#panel",
      transition: {
        "ease-in-out duration-500 sm:duration-700",
        "translate-x-full",
        "translate-x-0"
      }
    )
    |> JS.show(
      to: "#panel-bg",
      transition: "fade-in"
    )
    |> JS.add_class(
      "overflow-y-hidden",
      to: "#root-body"
    )
    |> JS.focus_first(to: "#panel-container")
  end

  defp hide_panel(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#panel",
      transition: {
        "ease-in-out duration-500 sm:duration-700",
        "translate-x-0",
        "translate-x-full"
      }
    )
    |> JS.hide(
      to: "#panel-bg",
      transition: "fade-out"
    )
    |> JS.remove_class(
      "overflow-y-hidden",
      to: "#root-body"
    )
    |> JS.pop_focus()
  end
end
