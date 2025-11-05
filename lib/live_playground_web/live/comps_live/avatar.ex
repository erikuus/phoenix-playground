defmodule LivePlaygroundWeb.CompsLive.Avatar do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    users = [
      %{email: "john.doe@example.com", inserted_at: ~N[2023-01-15 10:30:00]},
      %{email: "alice.smith@example.com", inserted_at: ~N[2023-03-22 14:20:00]},
      %{email: "bob.johnson@example.com", inserted_at: ~N[2023-05-10 09:15:00]},
      %{email: "michael.brown@example.com", inserted_at: ~N[2023-09-18 11:00:00]},
      %{email: "sarah.davis@example.com", inserted_at: ~N[2023-11-03 13:30:00]},
      %{
        email: "emma.wilson@example.com",
        inserted_at: ~N[2023-07-01 16:45:00],
        image_url: "/images/erik_uus.jpg"
      }
    ]

    {:ok, assign(socket, :users, users)}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Avatar
      <:subtitle>
        Displaying User Avatars with Initials in LiveView
      </:subtitle>
      <:actions>
        <.goto_definition filename="lib/live_playground_web/components/more_components.ex" definition="def avatar">
          Goto Definition
        </.goto_definition>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <div class="space-y-8">
      <div class="flex items-center space-x-3">
        <.avatar :for={user <- @users} user={user} />
      </div>
      <div>
        <h3 class="text-sm font-medium text-gray-700 mb-3">Custom Style</h3>
        <div class="flex items-center space-x-3">
          <.avatar user={Enum.at(@users, 0)} color="bg-zinc-900 hover:bg-zinc-700" />
          <.avatar user={Enum.at(@users, 1)} class="w-10 h-10 border-2 border-white shadow-lg" />
          <.avatar user={Enum.at(@users, 2)} class="w-12 h-12 border-2 border-gray-300" />
          <.avatar user={Enum.at(@users, 3)} class="w-14 h-14 ring-2 ring-offset-2 ring-blue-500" />
        </div>
      </div>
    </div>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/comps_live/avatar.ex" />
    </div>
    <!-- end hiding from live code -->
    """
  end
end
