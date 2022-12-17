defmodule LivePlaygroundWeb.Components.SingleActionComponent do
  use LivePlaygroundWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="relative transform overflow-hidden rounded-lg bg-white px-4 pt-5 pb-4 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-sm sm:p-6">
      <div>
        <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100">
          <!-- Heroicon name: outline/check -->
          <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
          </svg>
        </div>
        <div class="mt-3 text-center sm:mt-5">
          <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-title">Payment successful</h3>
          <div class="mt-2">
            <p class="text-sm text-gray-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Consequatur amet labore.</p>
          </div>
        </div>
      </div>
      <div class="mt-5 sm:mt-6">
        <button type="button" class="inline-flex w-full justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-base font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 sm:text-sm">Go back to dashboard</button>
      </div>
    </div>
    """
  end
end
