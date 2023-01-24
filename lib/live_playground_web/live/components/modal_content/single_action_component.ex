defmodule LivePlaygroundWeb.Live.ModalContent.SingleActionComponent do
  use LivePlaygroundWeb, :live_component

  import LivePlaygroundWeb.UiComponent
  import LivePlaygroundWeb.IconComponent

  def render(assigns) do
    ~H"""
    <div class="p-4 sm:p-6 sm:w-full sm:max-w-sm">
      <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
        <.icon name="check_mark" class="h-6 w-6 text-greem-600" />
      </div>
      <div class="mt-3 text-center sm:mt-5">
        <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title"><%= @title %></h3>
        <div class="mt-2">
          <p class="text-sm text-gray-500"><%= @description %></p>
        </div>
      </div>
      <div class="mt-5 sm:mt-6">
        <.button patch={@return_to} class="w-full">Go back to dashboard</.button>
      </div>
    </div>
    """
  end
end
