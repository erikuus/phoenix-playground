defmodule LivePlaygroundWeb.CompsLive.Setup do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Setup
      <:subtitle>
        Setting Up Core and MoreComponents
      </:subtitle>
    </.header>
    <div class="flex flex-col gap-x-0 gap-y-8 xl:flex-row xl:gap-x-10 xl:gap-y-0">
      <div class="flex-1 prose max-w-none rounded-lg bg-zinc-100 p-6">
        <h3>CoreComponents</h3>
        <p>
          In a new Phoenix application, you will find a CoreComponents module inside the components folder.
          This module is a great example of defining function components to be reused throughout your application.
        </p>
        <p>
          The CoreComponents also play an important role in Phoenix code generators, as the code generators assume those
          components are available.
        </p>
        <p>
          Note: The CoreComponents included in this playground have been slightly modified from the original source to
          better fit the specific needs and examples demonstrated here.
        </p>
        <.github_link filename="lib/live_playground_web/components/core_components.ex">
          core_components.ex
        </.github_link>
      </div>
      <div class="flex-1 prose max-w-none rounded-lg bg-zinc-100 p-6">
        <h3>MoreComponents</h3>
        <p>
          The MoreComponents are a bespoke suite that you'll discover within this playground. These are housed in a
          separate module crafted to complement the CoreComponents.
        </p>
        <p>
          The MoreComponents suite comprises a range of widgets and tools that can be particularly valuable when you're
          looking to add advanced features or custom user interface elements.
        </p>
        <p>
          Remember to import MoreComponents in your <code>web.ex</code> file to make them readily available for your
          LiveView applications, just as you would with CoreComponents.
        </p>
        <.github_link filename="lib/live_playground_web/components/more_components.ex">
          more_components.ex
        </.github_link>
      </div>
    </div>
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web.ex" from="# helpers" to="# endhelpers" />
    </div>
    """
  end
end
