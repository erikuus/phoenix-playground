defmodule LivePlaygroundWeb.Live.ModalComponent do
  @moduledoc """
  Provides modal component.

  This component can be used to

  * render any live component in modal

  * render confirmation dialog

  For convenience of the usage, you may want to define helper function as follows:

      def live_modal(component, opts, close_opts \\ %{capture_close: true, show_close_btn: false}) do
        live_component(
          MyWeb.ModalComponent,
          id: :modal,
          component: component,
          opts: opts,
          return_to: Keyword.fetch!(opts, :return_to),
          close_opts: close_opts
        )
      end

  Now you can render a confirmation dialog as follows:

      live_modal(:confirm_proceed,
        title: "Added to Cart",
        description: "Product name, amount ...",
        proceed_text: "Proceed to checkout",
        proceed_to: ~p"/shop/checkout",
        return_text: "Continue shopping",
        return_to: ~p"/shop"
      )

  Or you can render any live component in modal. For example:

      live_modal(
        MyWeb.AnyComponent,
        [
          heading: "Lorem ipsum",
          content: "Curabitur ut odio sed felis iaculis scelerisque.",
          return_to: ~p"/parent-page"
        ],
        %{capture_close: false, show_close_btn: true}
      )
  """
  use LivePlaygroundWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="relative z-10 hover:bg-red-500" aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
      <div class="fixed inset-0 z-10 overflow-y-auto">
        <div
          phx-capture-click="close"
          phx-window-keyup="close"
          phx-key="escape"
          phx-target={@myself}
          class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
        >
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:p-0">
            <div :if={@close_opts.show_close_btn} class="absolute top-0 right-0 hidden pt-4 pr-4 sm:block">
              <.link patch={@return_to}>
                <svg
                  class="w-6 h-6 text-gray-400 hover:text-gray-500"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </.link>
            </div>
            <%= if is_confirm_type(@component) do %>
              <.confirm type={@component} opts={Enum.into(@opts, %{})} />
            <% else %>
              <%= live_component(@component, @opts) %>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("close", _, socket) do
    socket =
      if socket.assigns.close_opts.capture_close do
        push_patch(socket, to: socket.assigns.return_to)
      else
        socket
      end

    {:noreply, socket}
  end

  defp is_confirm_type(component) do
    if component in [:confirm_return, :confirm_proceed, :confirm_action], do: true, else: false
  end

  @doc """
  Renders the contents of a confirmation dialog.

  The following types can be used:

  * `:confirm_return` - Renders one full with pirmary button to return (to parent page)
  * `:confirm_proceed` - Renders one wide primary button to proceed and another one to return
  * `:confirm_action` - Renders danger action and cancel button on the right side

  ## Examples

      <.confirm type={:confirm_return} opts={@opts} />
      <.confirm type={:confirm_proceed} opts={@opts} />
      <.confirm type={:confirm_action} opts={@opts} />
  """
  attr :type, :atom, required: true
  attr :opts, :map, required: true

  def confirm(%{type: :confirm_return} = assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-sm">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
        <svg
          class="h-6 w-6 text-green-600"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
        </svg>
      </div>

      <div class="mt-3 text-center sm:mt-5">
        <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title">
          <%= @opts.title %>
        </h3>

        <div class="mt-2">
          <p class="text-sm text-gray-500"><%= @opts.description %></p>
        </div>
      </div>

      <div class="mt-5 sm:mt-6">
        <.button_link patch={@opts.return_to} class="w-full"><%= @opts.return_text %></.button_link>
      </div>
    </div>
    """
  end

  def confirm(%{type: :confirm_proceed} = assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-lg">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
        <svg
          class="h-6 w-6 text-green-600"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
        </svg>
      </div>

      <div class="mt-3 text-center sm:mt-5">
        <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title">
          <%= @opts.title %>
        </h3>

        <div class="mt-2">
          <p class="text-sm text-gray-500"><%= @opts.description %></p>
        </div>
      </div>

      <div class="mt-5 sm:mt-6 sm:grid sm:grid-flow-row-dense sm:grid-cols-2 sm:gap-3">
        <.button_link patch={@opts.proceed_to} type="primary" class="w-full">
          <%= @opts.proceed_text %>
        </.button_link>

        <.button_link patch={@opts.return_to} type="secondary" class="w-full mt-3 sm:mt-0">
          <%= @opts.return_text %>
        </.button_link>
      </div>
    </div>
    """
  end

  def confirm(%{type: :confirm_action} = assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-lg">
      <div class="sm:flex sm:items-start">
        <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
          <svg
            class="h-6 w-6 text-red-600"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            aria-hidden="true"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M12 10.5v3.75m-9.303 3.376C1.83 19.126 2.914 21 4.645 21h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 4.88c-.866-1.501-3.032-1.501-3.898 0L2.697 17.626zM12 17.25h.007v.008H12v-.008z"
            />
          </svg>
        </div>

        <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
          <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title">
            <%= @opts.title %>
          </h3>

          <div class="mt-2">
            <p class="text-sm text-gray-500"><%= @opts.description %></p>
          </div>
        </div>
      </div>

      <div class="mt-5 sm:mt-4 sm:ml-10 sm:pl-4 sm:flex sm:flex-row-reverse">
        <.button_link patch={@opts.return_to} type="secondary" class="w-full sm:w-auto">
          <%= @opts.return_text %>
        </.button_link>

        <.button_link patch={@opts.action_to} type="dangerous" class="w-full sm:w-auto mt-3 sm:mt-0 sm:mr-3">
          <%= @opts.action_text %>
        </.button_link>
      </div>
    </div>
    """
  end
end
