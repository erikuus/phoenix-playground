defmodule LivePlaygroundWeb.RecipesLive.ChangeForm do
  use LivePlaygroundWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        event_type: "conference",
        ticket_type: "regular"
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Change Form
      <:subtitle>
        Handling Form Changes in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form id="event-registration-form" class="space-y-5" phx-change="update_form">
      <.input type="select" label="Event Type" name="event_type" options={get_event_type_options()} value={@event_type} />
      <.event_specific_fields event_type={@event_type} />
      <div class="ml-1 space-y-2">
        <label class="text-sm font-medium text-gray-700">Ticket Type</label>
        <.input type="radio" name="ticket_type" label="Regular" id="regular" value="regular" checked={@ticket_type == "regular"} />
        <.input type="radio" name="ticket_type" label="VIP" id="vip" value="vip" checked={@ticket_type == "vip"} />
        <.vip_preferences ticket_type={@ticket_type} />
        <.input type="radio" name="ticket_type" label="Student" id="student" value="student" checked={@ticket_type == "student"} />
        <.student_verification ticket_type={@ticket_type} />
      </div>
    </form>
    <!-- start hiding from live code -->
    <div class="mt-10">
      <.code_block filename="lib/live_playground_web/live/recipes_live/change_form.ex" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/change_form.html" />
    <!-- end hiding from live code -->
    """
  end

  defp event_specific_fields(%{event_type: "conference"} = assigns) do
    ~H"""
    <div id="conference-fields" phx-update="ignore" class="space-y-4 ml-9">
      <.input
        type="text"
        id="dietary-restrictions"
        label="Dietary Restrictions"
        name="dietary_restrictions"
        value=""
        placeholder="e.g., Vegetarian, Gluten-free"
      />
      <.input
        type="select"
        id="session-track"
        label="Preferred Session Track"
        name="session_track"
        value=""
        options={get_session_track_options()}
      />
    </div>
    """
  end

  defp event_specific_fields(%{event_type: "workshop"} = assigns) do
    ~H"""
    <div id="workshop-fields" phx-update="ignore" class="space-y-4 ml-9">
      <.input
        type="select"
        id="skill-level"
        label="Current Skill Level"
        name="skill_level"
        value=""
        options={get_skill_level_options()}
      />
      <.input
        type="textarea"
        id="goals"
        label="Learning Goals"
        name="learning_goals"
        value=""
        placeholder="What do you hope to achieve?"
      />
    </div>
    """
  end

  defp event_specific_fields(assigns) do
    ~H"""
    """
  end

  defp vip_preferences(%{ticket_type: "vip"} = assigns) do
    ~H"""
    <div id="vip-preferences" phx-update="ignore" class="mt-2 ml-8 space-y-3">
      <.input type="checkbox" name="vip_lounge" id="vip-lounge" label="Access to VIP Lounge" value="true" checked={false} />
      <.input type="checkbox" name="priority_seating" id="priority-seating" label="Priority Seating" value="true" checked={false} />
      <.input
        type="checkbox"
        name="welcome_package"
        id="welcome-package"
        label="Premium Welcome Package"
        value="true"
        checked={false}
      />
    </div>
    """
  end

  defp vip_preferences(assigns) do
    ~H"""
    """
  end

  defp student_verification(%{ticket_type: "student"} = assigns) do
    ~H"""
    <div id="student-verification" phx-update="ignore" class="mt-2 ml-8 space-y-3">
      <.input type="text" id="university" label="University/School Name" name="university" value="" />
      <.input type="text" id="student-id" label="Student ID" name="student_id" value="" />
    </div>
    """
  end

  defp student_verification(assigns) do
    ~H"""
    """
  end

  def handle_event(
        "update_form",
        %{"event_type" => event_type, "ticket_type" => ticket_type},
        socket
      ) do
    socket =
      assign(socket,
        event_type: event_type,
        ticket_type: ticket_type
      )

    {:noreply, socket}
  end

  defp get_event_type_options do
    [
      {"Conference", "conference"},
      {"Workshop", "workshop"},
      {"Webinar", "webinar"}
    ]
  end

  defp get_session_track_options do
    [
      {"Technology", "tech"},
      {"Business", "business"},
      {"Design", "design"}
    ]
  end

  defp get_skill_level_options do
    [
      {"Beginner", "beginner"},
      {"Intermediate", "intermediate"},
      {"Advanced", "advanced"}
    ]
  end
end
