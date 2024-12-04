defmodule LivePlaygroundWeb.PaginationHelpers do
  import Phoenix.LiveView
  import Phoenix.Component

  @per_page_options [5, 10, 20, 50, 100]
  @default_per_page 10

  @doc """
  Converts pagination parameters from the given `params` map, applying default values when necessary.

  This function safely extracts the `"page"` and `"per_page"` parameters from the provided `params` map,
  converting them to integers and applying default values if they are missing or invalid. It's useful for
  ensuring that pagination parameters are always in a consistent and expected format.

  ## Parameters

  - `params`: A map of parameters, typically extracted from the URL or user input.

  ## Returns

  A map containing the converted pagination parameters:

  - `:page` - The current page number (defaults to `1`).
  - `:per_page` - The number of items per page (defaults to `@default_per_page`).

  ## Examples

  ```elixir
  iex> params = %{"page" => "2", "per_page" => "20"}
  iex> PaginationHelpers.convert_params(params)
  %{page: 2, per_page: 20}

  iex> params = %{}
  iex> PaginationHelpers.convert_params(params)
  %{page: 1, per_page: 10}

  iex> params = %{"page" => "abc", "per_page" => "xyz"}
  iex> PaginationHelpers.convert_params(params)
  %{page: 1, per_page: 10}
  """
  def convert_params(params) do
    %{
      page: to_integer(params["page"], 1),
      per_page: to_integer(params["per_page"], @default_per_page)
    }
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
  Validates pagination options, ensuring that `page` and `per_page` are within acceptable ranges.

  This function adjusts the `page` and `per_page` values based on the total count of items (`count_all`) and
  the allowed `per_page` options. It ensures that the `page` number does not exceed the maximum available pages
  and that `per_page` is one of the allowed values.

  ## Parameters

  - `count_all`: The total number of items available (e.g., total records in the database).
  - `options`: A map containing the current pagination options (`:page` and `:per_page`).

  ## Returns

  A map with validated and possibly adjusted pagination options:

  - `:page` - The validated page number.
  - `:per_page` - The validated number of items per page.

  ## Examples

  ```elixir
  iex> count_all = 50
  iex> options = %{page: 3, per_page: 10}
  iex> PaginationHelpers.validate_options(count_all, options)
  %{page: 3, per_page: 10}

  iex> options = %{page: 6, per_page: 10}
  iex> PaginationHelpers.validate_options(count_all, options)
  %{page: 5, per_page: 10} # Adjusted to the last available page

  iex> options = %{page: 1, per_page: 15}
  iex> PaginationHelpers.validate_options(count_all, options)
  %{page: 1, per_page: 10} # Adjusted to the default per_page
  ```
  """
  def validate_options(count_all, options) do
    per_page = get_allowed_per_page(options.per_page)
    page = get_existing_page(options.page, per_page, count_all)

    %{page: page, per_page: per_page}
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

  defp get_allowed_per_page(per_page) do
    per_page = to_integer(per_page, @default_per_page)
    if per_page in @per_page_options, do: per_page, else: @default_per_page
  end

  @doc """
  Returns the list of allowed `per_page` options for pagination.

  This function provides the available options for the number of items displayed per page,
  typically used to populate a select dropdown in the UI.

  ## Returns

  A list of integers representing the allowed `per_page` options.

  ## Examples

  ```heex
  <.input type="select" name="per_page" options={PaginationHelpers.get_per_page_select_options()} value={@options.per_page} />
  ```
  """
  def get_per_page_select_options, do: @per_page_options

  @doc """
  Updates the `per_page` option in the pagination settings based on user input.

  This function extracts the `"per_page"` parameter from the provided `params` map, converts it to an integer,
  and updates the `per_page` value in the current pagination options stored in the `socket`.

  ## Parameters

  - `socket`: The LiveView socket containing the current assigns.
  - `params`: A map of parameters, typically from user input or a form submission.

  ## Returns

  An updated map of pagination options with the new `per_page` value.

  ## Examples

  ```elixir
  # Given the current options in the socket:
  socket.assigns.options = %{page: 2, per_page: 10}

  # User changes per_page to 20:
  params = %{"per_page" => "20"}
  PaginationHelpers.update_per_page_option(socket, params)
  # Returns: %{page: 2, per_page: 20}
  ```
  """
  def update_per_page_option(socket, params) do
    options = socket.assigns.options || %{page: 1, per_page: @default_per_page}
    per_page = to_integer(params["per_page"], @default_per_page)
    %{options | per_page: per_page}
  end

  @doc """
  Initializes pagination by setting up the necessary assigns and streaming data into the socket.

  This function prepares the socket for pagination by assigning options, counts, and initializing the data stream.
  It's typically called during the `mount/3` phase of a LiveView.

  ## Parameters

  - `socket`: The LiveView socket.
  - `options`: A map containing validated pagination options (`:page` and `:per_page`).
  - `stream_name`: An atom representing the name of the data stream (e.g., `:items`).
  - `fetch_data_fn`: A function that accepts pagination options and returns a list of data items.

  ## Returns

  The updated socket with pagination assigns and data stream initialized.

  ## Examples

  ```elixir
  fetch_data_fn = fn options -> MyApp.list_items(options) end
  PaginationHelpers.init(socket, %{page: 1, per_page: 10}, :items, fetch_data_fn)
  ```
  """
  def init(socket, options, stream_name, fetch_data_fn) do
    count_all = socket.assigns.count_all
    per_page = options.per_page
    count_visible_rows = min(count_all, per_page)
    data = fetch_data_fn.(options)

    socket
    |> assign(:options, options)
    |> assign(:count_all_summary, count_all)
    |> assign(:count_all_pagination, count_all)
    |> assign(:count_visible_rows, count_visible_rows)
    |> assign(:pending_deletion, false)
    |> stream(stream_name, data)
  end

  @doc """
  Applies pagination options and updates the socket accordingly, handling data reloads and stream resets.

  This function manages the pagination logic, determining whether data needs to be reloaded based on changes
  in parameters or options. It updates the socket assigns and streams new data when necessary.

  ## Parameters

  - `socket`: The LiveView socket.
  - `action`: The current LiveView action (e.g., `:index`).
  - `params`: A map of parameters from the URL or user input.
  - `stream_name`: An atom representing the name of the data stream.
  - `fetch_data_fn`: A function that accepts pagination options and returns a list of data items.
  - `fetch_url_fn`: A function that generates a URL based on pagination options.
  - `reset_stream`: A boolean indicating whether to force a data reload (e.g., after a reset action). Typically used
    in scenarios where newly added, edited, or deleted items should remain visible in the current view (), even if they
    don’t naturally belong to the page based on sorting or pagination. In such cases, users are provided a reset link
    in the flash message to refresh and see the updated list in its proper sorted state.

  ## Returns

  The updated socket with applied pagination options and data.

  ## Examples

  ```elixir
  fetch_data_fn = fn options -> MyApp.list_items(options) end
  fetch_url_fn = fn options -> Routes.items_path(MyAppWeb.Endpoint, :index, options) end
  PaginationHelpers.apply_options(
  socket,
  :index,
  params,
  :items,
  fetch_data_fn,
  fetch_url_fn,
  false
  )
  ```
  """
  def apply_options(
        socket,
        :index,
        params,
        stream_name,
        fetch_data_fn,
        fetch_url_fn,
        reset_stream
      ) do
    options = socket.assigns.options || %{page: 1, per_page: @default_per_page}

    # Extract parameters with fallbacks
    page = params["page"] || options.page || 1
    per_page = params["per_page"] || options.per_page || @default_per_page

    # Convert and validate parameters
    page = to_integer(page, 1)
    per_page = to_integer(per_page, @default_per_page)
    new_options = %{page: page, per_page: per_page}
    valid_options = validate_options(socket.assigns.count_all, new_options)

    # Check if data needs to be reloaded
    socket =
      if reset_stream or valid_options != options or valid_options.page != page do
        data = fetch_data_fn.(valid_options)
        count_visible_rows = length(data)

        socket
        |> assign(:options, valid_options)
        |> assign(:count_visible_rows, count_visible_rows)
        |> assign(:count_all_summary, socket.assigns.count_all)
        |> assign(:count_all_pagination, socket.assigns.count_all)
        |> assign(:pending_deletion, false)
        |> stream(stream_name, data, reset: true)
        |> (&if(valid_options.page != page,
              do: push_patch(&1, to: fetch_url_fn.(valid_options)),
              else: &1
            )).()
      else
        socket
      end

    socket
  end

  def apply_options(socket, _, _, _, _, _, _), do: socket

  @doc """
  Handles the creation of a new item by updating counts and inserting the item into the data stream.

  This function is used when a new item is created, either by the current user or another user.
  It updates the total counts and marks the item with a `:created` flag for UI distinction.

  ## Parameters

  - `socket`: The LiveView socket.
  - `stream_name`: An atom representing the name of the data stream.
  - `item`: The newly created item to be inserted into the stream.

  ## Returns

  The updated socket with counts incremented and the new item inserted into the stream.

  ## Examples

  ```elixir
  item = %Item{id: 123, name: "New Item"}
  PaginationHelpers.handle_created(socket, :items, item)
  ```
  """
  def handle_created(socket, stream_name, item) do
    item = Map.put(item, :created, true)

    socket
    |> update(:count_all, &(&1 + 1))
    |> update(:count_visible_rows, &(&1 + 1))
    |> update(:count_all_summary, &(&1 + 1))
    |> stream_insert(stream_name, item, at: 0)
  end

  @doc """
  Handles the update of an existing item by updating it in the data stream.

  This function is used when an item is updated, either by the current user or another user.
  It marks the item with an `:updated` flag for UI distinction.

  ## Parameters

  - `socket`: The LiveView socket.
  - `stream_name`: An atom representing the name of the data stream.
  - `item`: The updated item to be refreshed in the stream.

  ## Returns

  The updated socket with the item refreshed in the stream.

  ## Examples

  ```elixir
  item = %Item{id: 123, name: "Updated Item"}
  PaginationHelpers.handle_updated(socket, :items, item)
  ```
  """
  def handle_updated(socket, stream_name, item) do
    item = Map.put(item, :updated, true)
    stream_insert(socket, stream_name, item)
  end

  @doc """
  Handles the deletion of an item by updating counts and marking the item as deleted in the data stream.

  This function is used when an item is deleted, either by the current user or another user.
  It decrements the total counts, sets the `:pending_deletion` flag, and marks the item with a `:deleted` flag
  for UI distinction.

  ## Parameters

  - `socket`: The LiveView socket.
  - `stream_name`: An atom representing the name of the data stream.
  - `item`: The deleted item to be marked in the stream.

  ## Returns

  The updated socket with counts decremented and the item marked as deleted in the stream.

  ## Examples

  ```elixir
  item = %Item{id: 123, name: "Deleted Item"}
  PaginationHelpers.handle_deleted(socket, :items, item)
  ```
  """
  def handle_deleted(socket, stream_name, item) do
    item = Map.put(item, :deleted, true)

    socket
    |> update(:count_all, &(&1 - 1))
    |> assign(:pending_deletion, true)
    |> stream_insert(stream_name, item)
  end

  @doc """
  Generates a summary string for the current page in the pagination view.

  This function calculates the starting and ending item numbers displayed on the current page
  and returns a string summarizing this information.

  ## Parameters

  - `count_all`: The total number of items available.
  - `page`: The current page number.
  - `per_page`: The number of items per page.
  - `stream_size`: The actual number of items in the current data stream.

  ## Returns

  A string summarizing the items being displayed, in the format:

  "Showing X - Y of Z."

  Where:
  - `X` is the starting item number.
  - `Y` is the ending item number.
  - `Z` is the total number of items.

  ## Examples

  ```elixir
  iex> PaginationHelpers.get_summary(100, 2, 10, 10)
  "Showing 11 - 20 of 100."

  iex> PaginationHelpers.get_summary(45, 5, 10, 5)
  "Showing 41 - 45 of 45."
  ```
  """
  def get_summary(count_all, page, per_page, stream_size) do
    start = (page - 1) * per_page + 1
    ending = min(start + stream_size - 1, count_all)

    "Showing #{start} - #{ending} of #{count_all}."
  end
end
