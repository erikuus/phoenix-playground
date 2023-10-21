defmodule LivePlaygroundWeb.CompsLive.Alert do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Alert
      <:subtitle>
        How to use Alert component
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def alert">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="grid gap-6 grid-cols-1 xl:grid-cols-2">
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With text only
        </h2>
        <.alert id="info" close={false}>Default: <%= placeholder_sentences(3, true) %></.alert>
        <.alert id="success" kind={:success} close={false}>Success: <%= placeholder_sentences(3, true) %></.alert>
        <.alert id="warning" kind={:warning} close={false}>Warning: <%= placeholder_sentences(3, true) %></.alert>
        <.alert id="error" kind={:error} close={false}>Error: <%= placeholder_sentences(3, true) %></.alert>
      </div>
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With title
        </h2>
        <.alert id="info-title" title="Default with title"><%= placeholder_sentences(1, true) %></.alert>
        <.alert id="success-title" title="Success with title" kind={:success}><%= placeholder_sentences(1, true) %></.alert>
        <.alert id="warning-title" title="Warning with title" kind={:warning}><%= placeholder_sentences(1, true) %></.alert>
        <.alert id="error-title" title="Error with title" kind={:error}><%= placeholder_sentences(1, true) %></.alert>
      </div>
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With icon
        </h2>
        <.alert id="info-icon" title="Default with icon" icon="hero-information-circle-mini">
          <%= placeholder_sentences(1, true) %>
        </.alert>
        <.alert id="success-icon" title="Success with icon" icon="hero-check-circle-mini" kind={:success}>
          <%= placeholder_sentences(1, true) %>
        </.alert>
        <.alert id="warning-icon" title="Warning with icon" icon="hero-exclamation-triangle-mini" kind={:warning}>
          <%= placeholder_sentences(1, true) %>
        </.alert>
        <.alert id="error-icon" title="Error with icon" icon="hero-exclamation-circle-mini" kind={:error}>
          <%= placeholder_sentences(1, true) %>
        </.alert>
      </div>
      <div class="space-y-2">
        <h2 class="truncate font-medium leading-7 text-zinc-500 mb-4">
          With custom style
        </h2>
        <.alert
          id="custom"
          class="rounded-lg p-8 text-base bg-blue-50 text-blue-700 leading-relaxed"
          title="Custom style"
          icon="hero-face-smile-mini"
        >
          <%= placeholder_sentences(6, true) %>
        </.alert>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/comps_live/alert.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
