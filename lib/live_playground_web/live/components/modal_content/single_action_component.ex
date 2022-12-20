defmodule LivePlaygroundWeb.Components.ModalContent.SingleActionComponent do
  use LivePlaygroundWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-sm">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
        <!-- Heroicon name: outline/check -->
        <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
        </svg>
      </div>
      <div class="mt-3 text-center sm:mt-5">
        <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title"><%= @title %></h3>
        <div class="mt-2">
          <p class="text-sm text-gray-500"><%= @description %></p>
        </div>
      </div>
      <div class="mt-5 sm:mt-6">
        <%= live_patch "Go back to dashboard",
          class: "#{tw_button_classes()} w-full text-base sm:text-sm",
          to: @return_to %>
      </div>
    </div>
    """
  end
end
