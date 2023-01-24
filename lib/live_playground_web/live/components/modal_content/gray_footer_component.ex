defmodule LivePlaygroundWeb.Live.ModalContent.GrayFooterComponent do
  use LivePlaygroundWeb, :live_component

  import LivePlaygroundWeb.UiComponent
  import LivePlaygroundWeb.IconComponent

  def render(assigns) do
    ~H"""
    <div class="sm:w-full sm:max-w-lg">
      <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
        <div class="sm:flex sm:items-start">
          <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
            <.icon name="exclamation_triangle" class="h-6 w-6 text-red-600" />
          </div>
          <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
            <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title"><%= @title %></h3>
            <div class="mt-2">
              <p class="text-sm text-gray-500"><%= @description %></p>
            </div>
          </div>
        </div>
      </div>
      <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
        <.button patch={@go_to} color={:dangerous} class="w-full sm:w-auto">Deactivate</.button>
        <.button patch={@return_to} color={:secondary} class="w-full sm:w-auto mt-3 sm:mt-0 sm:mr-3">Cancel</.button>
      </div>
    </div>
    """
  end
end
