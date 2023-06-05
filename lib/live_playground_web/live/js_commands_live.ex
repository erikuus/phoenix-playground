defmodule LivePlaygroundWeb.JsCommandsLive do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      JS Commands
      <:subtitle>
        How to handle javascript in LiveView
      </:subtitle>
      <:actions>
        <.link navigate={~p"/js-commands-real"}>
          See also: Real World Example of JS Commands<.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button phx-click={toggle_slideover()}>Show slideover</.button>
    <div class="relative z-50" aria-labelledby="slide-over-title" role="dialog" aria-modal="true">
      <div id="slideover-bg" class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity hidden" />
      <div id="slideover" class="fixed inset-0 overflow-hidden hidden">
        <div class="absolute inset-0 overflow-hidden">
          <div class="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10">
            <div class="pointer-events-auto w-screen max-w-md">
              <div phx-click-away={toggle_slideover()} class="flex h-full flex-col overflow-y-auto bg-white py-6 shadow-xl">
                <div class="px-4 sm:px-6">
                  <div class="flex items-start justify-between">
                    <h2 class="text-base font-semibold leading-6 text-gray-900" id="slide-over-title">Panel title</h2>
                    <div class="ml-3 flex h-7">
                      <button phx-click={toggle_slideover()} type="button">
                        <.icon name="hero-x-mark" class="h-6 w-6" />
                      </button>
                    </div>
                  </div>
                </div>
                <div class="relative mt-6 flex-1 px-4 sm:px-6">
                  Panel content
                </div>
              </div>
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

  def toggle_slideover do
    JS.toggle(
      to: "#slideover",
      in: {
        "ease-in-out duration-500 sm:duration-700",
        "translate-x-full",
        "translate-x-0"
      },
      out: {
        "ease-in-out duration-500 sm:duration-700",
        "translate-x-0",
        "translate-x-full"
      }
    )
    |> JS.toggle(
      to: "#slideover-bg",
      in: "fade-in",
      out: "fade-out"
    )
  end
end
