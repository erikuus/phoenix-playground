defmodule LivePlaygroundWeb.PaginationHelpers do
  @moduledoc """
  Provides a suite of functions and a configurable `Context` struct for handling
  pagination-related logic in Phoenix LiveView modules.
  """

  import Phoenix.LiveView
  import Phoenix.Component

  defmodule Context do
    @moduledoc """
    A configuration struct for pagination.

    Fields:
      - `stream_name`: The name of the data stream (atom)
      - `fetch_data_fn`: A function that takes pagination options and returns a list of data
      - `fetch_url_fn`: A function that takes pagination options and returns a URL
      - `per_page_options`: A list of allowed `per_page` values
      - `default_per_page`: The default `per_page` value if none is provided or invalid
    """
    defstruct [
      :stream_name,
      :fetch_data_fn,
      :fetch_url_fn,
      per_page_options: [5, 10, 20, 50, 100],
      default_per_page: 10
    ]
  end

  @doc """
  Converts pagination parameters from string to integer values and merges them with existing options.

  ## Parameters
    - `options`: The existing pagination options map
    - `socket`: The LiveView socket with assigned `context`
    - `params`: A map of parameters from URL or user input

  ## Returns
    A map `%{page: integer, per_page: integer}` with converted and merged pagination parameters
  """
  def convert_params(options, socket, %{"page" => page, "per_page" => per_page} = _params) do
    context = socket.assigns.context
    page = to_integer(page, 1)
    per_page = to_integer(per_page, context.default_per_page)
    Map.merge(options, %{page: page, per_page: per_page})
  end

  def convert_params(options, socket, _params) do
    context = socket.assigns.context
    Map.merge(options, %{page: 1, per_page: context.default_per_page})
  end

  defp to_integer(value, _default_value) when is_integer(value), do: value

  defp to_integer(value, default_value) when is_binary(value) do
    case Integer.parse(value) do
      {i, _} when i > 0 -> i
      _ -> default_value
    end
  end

  defp to_integer(_value, default_value), do: default_value

  @doc """
  Validates pagination options against the total item count and context configuration.

  ## Parameters
    - `options`: The pagination options to validate
    - `socket`: The LiveView socket with assigned `context`, `count_all`, and `options`

  ## Returns
    A map `%{page: integer, per_page: integer}` with validated pagination parameters
  """
  def validate_options(%{page: page, per_page: per_page} = options, socket) do
    context = socket.assigns.context
    count_all = socket.assigns.count_all

    per_page = get_allowed_per_page(per_page, context)
    page = get_existing_page(page, per_page, count_all)

    %{options | page: page, per_page: per_page}
  end

  def validate_options(options, _socket) do
    options
  end

  defp get_existing_page(page, per_page, count_all) do
    max_page = ceil_div(count_all, per_page)

    cond do
      max_page == 0 -> 1
      page > max_page -> max_page
      page < 1 -> 1
      true -> page
    end
  end

  defp ceil_div(_num, 0), do: 0
  defp ceil_div(num, denom), do: div(num + denom - 1, denom)

  defp get_allowed_per_page(per_page, context) do
    per_page = to_integer(per_page, context.default_per_page)
    if per_page in context.per_page_options, do: per_page, else: context.default_per_page
  end

  @doc """
  Updates the per_page option based on user input.

  ## Parameters
    - `socket`: The LiveView socket with assigned `context` and `options`
    - `params`: User input parameters containing "per_page"

  ## Returns
    Updated options map with the new per_page value
  """
  def update_per_page_option(socket, %{"per_page" => per_page_param}) do
    context = socket.assigns.context
    options = socket.assigns.options
    per_page = to_integer(per_page_param, context.default_per_page)
    %{options | per_page: per_page}
  end

  def update_per_page_option(socket, _) do
    socket.assigns.options
  end

  @doc """
  Initializes pagination state by fetching data and assigning values to socket.

  ## Parameters
    - `socket`: The LiveView socket with assigned `context`, `count_all`, and `options`
    - `options`: Validated pagination options

  ## Returns
    Updated socket with pagination assigns and streamed data
  """
  def init(socket, options) do
    context = socket.assigns.context
    count_all = socket.assigns.count_all
    per_page = options.per_page
    count_visible_rows = min(count_all, per_page)
    data = context.fetch_data_fn.(options)

    socket
    |> assign(:options, options)
    |> assign(:count_all_summary, count_all)
    |> assign(:count_all_pagination, count_all)
    |> assign(:count_visible_rows, count_visible_rows)
    |> assign(:pending_deletion, false)
    |> stream(context.stream_name, data)
  end

  @doc """
  Applies pagination options on parameter changes or resets.

  ## Parameters
    - `socket`: The LiveView socket with assigned `context`, `options`, and `count_all`
    - `action`: The current LiveView action
    - `params`: A map of new parameters from URL or user input
    - `reset_stream`: Boolean indicating if data should be reloaded

  ## Returns
    Updated socket with applied pagination options
  """
  def apply_options(socket, :index, params, reset_stream) do
    context = socket.assigns.context
    options = socket.assigns.options

    page = params["page"] || options.page || 1
    per_page = params["per_page"] || options.per_page || context.default_per_page

    page = to_integer(page, 1)
    per_page = to_integer(per_page, context.default_per_page)
    new_options = Map.merge(options, %{page: page, per_page: per_page})
    valid_options = validate_options(new_options, socket)

    socket =
      if reset_stream or valid_options != options or valid_options.page != page do
        data = context.fetch_data_fn.(valid_options)
        count_all = socket.assigns.count_all
        count_visible_rows = length(data)

        socket
        |> assign(:options, valid_options)
        |> assign(:count_visible_rows, count_visible_rows)
        |> assign(:count_all_summary, count_all)
        |> assign(:count_all_pagination, count_all)
        |> assign(:pending_deletion, false)
        |> stream(context.stream_name, data, reset: true)
        |> (&if(valid_options.page != page,
              do: push_patch(&1, to: context.fetch_url_fn.(valid_options)),
              else: &1
            )).()
      else
        socket
      end

    socket
  end

  def apply_options(socket, _, _, _), do: socket

  @doc """
  Handles the creation of a new item in the data stream.

  ## Parameters
    - `socket`: The LiveView socket with assigned `context`
    - `item`: The newly created item to insert

  ## Returns
    Updated socket with incremented counts and inserted item
  """
  def handle_created(socket, item) do
    context = socket.assigns.context
    item = Map.put(item, :created, true)

    socket
    |> update(:count_all, &(&1 + 1))
    |> update(:count_visible_rows, &(&1 + 1))
    |> update(:count_all_summary, &(&1 + 1))
    |> stream_insert(context.stream_name, item, at: 0)
  end

  @doc """
  Handles the update of an existing item in the data stream.

  ## Parameters
    - `socket`: The LiveView socket with assigned `context`
    - `item`: The updated item to refresh

  ## Returns
    Updated socket with refreshed item in stream
  """
  def handle_updated(socket, item) do
    context = socket.assigns.context
    item = Map.put(item, :updated, true)
    stream_insert(socket, context.stream_name, item)
  end

  @doc """
  Handles the deletion of an item from the data stream.

  ## Parameters
    - `socket`: The LiveView socket with assigned `context`
    - `item`: The item to mark as deleted

  ## Returns
    Updated socket with marked item and adjusted counts
  """
  def handle_deleted(socket, item) do
    context = socket.assigns.context
    item = Map.put(item, :deleted, true)

    socket
    |> update(:count_all, &(&1 - 1))
    |> assign(:pending_deletion, true)
    |> stream_insert(context.stream_name, item)
  end

  @doc """
  Generates a summary string for the current page.

  ## Parameters
    - `count_all`: Total number of items
    - `page`: Current page number
    - `per_page`: Items per page
    - `stream_size`: Number of items currently streamed

  ## Returns
    String in format "Showing X - Y of Z"
  """
  def get_summary(count_all, page, per_page, stream_size) do
    start = (page - 1) * per_page + 1
    ending = min(start + stream_size - 1, count_all)
    "Showing #{start} - #{ending} of #{count_all}."
  end
end
