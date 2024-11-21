defmodule LivePlaygroundWeb.RecipesLive.JsCommands do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      JS Commands
      <:subtitle>
        Using JavaScript Commands to Toggle Elements in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <.button phx-click={show_panel()}>
      Show
    </.button>
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
              </.focus_wrap>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/js_commands.ex" />
      <.note icon="hero-information-circle">
        Please be aware that in this recipe, we have designed the slideover to showcase
        JavaScript commands. If you require a slideover in your application, kindly refer to <.link
          class="underline"
          navigate={~p"/slideover"}
        >slideover component</.link>.
      </.note>
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/js_commands.html" />
    <!-- end hiding from live code -->
    """
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
