defmodule LivePlaygroundWeb.PaginationHelpers do
  @moduledoc """
  Provides a suite of functions and a configurable `Context` struct for handling
  pagination-related logic in Phoenix LiveView modules.
  """

  defmodule Context do
    @moduledoc """
    A configuration struct that defines pagination behavior and constraints.

    Fields:
      - `per_page_options`: A list of allowed `per_page` values (e.g., [5, 10, 20, 50, 100])
      - `default_per_page`: The default number of items per page when not specified or invalid
    """
    defstruct per_page_options: [5, 10, 20, 50, 100],
              default_per_page: 10
  end

  @doc """
  Converts pagination parameters to integers and merges them into options map.

  ## Parameters
    - `options`: Target options map to merge pagination values into
    - `params`: Request parameters that may contain "page" and "per_page" strings
    - `context`: Pagination context containing default_per_page setting

  ## Returns
    Options map with :page and :per_page integers, either:
    - Converted from params if present
    - Or set to defaults (page: 1, per_page: context.default_per_page)
  """
  def convert_params(options, %{"page" => page, "per_page" => per_page} = _params, context) do
    page = to_integer(page, 1)
    per_page = to_integer(per_page, context.default_per_page)
    Map.merge(options, %{page: page, per_page: per_page})
  end

  def convert_params(options, _params, context) do
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
  Validates and adjusts pagination values to ensure they are within allowed bounds.

  If both :page and :per_page exist in options:
  - Ensures per_page is one of the allowed values from context
  - Adjusts page number to not exceed maximum possible pages based on count_all
  - Updates options with corrected values

  If :page or :per_page are missing from options, returns options unchanged.

  ## Parameters
    - `options`: Map that may contain :page and :per_page integers
    - `count_all`: Total number of items in collection being paginated
    - `context`: Contains allowed per_page_options and default_per_page

  ## Returns
    Options map with either:
    - Validated/adjusted :page and :per_page values
    - Or unchanged if pagination keys were missing
  """
  def validate_options(%{page: page, per_page: per_page} = options, count_all, context) do
    per_page = get_allowed_per_page(per_page, context)
    page = get_existing_page(page, per_page, count_all)
    %{options | page: page, per_page: per_page}
  end

  def validate_options(options, _count_all, _context) do
    options
  end

  defp get_allowed_per_page(per_page, context) do
    per_page = to_integer(per_page, context.default_per_page)
    if per_page in context.per_page_options, do: per_page, else: context.default_per_page
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

  @doc """
  Initializes pagination assigns with counts and visible rows.

  Sets up initial pagination state:
  - :pagination_context - Pagination context from module
  - :count_all - Total items
  - :count_all_summary - Total items for summary
  - :count_all_pagination - Total items for pagination
  - :count_visible_rows - Currently visible rows
  - :pending_deletion - Deletion in progress flag

  ## Parameters
    - `options` - Pagination options with optional :per_page
    - `count_all` - Total number of items
    - `context` - Pagination context with defaults

  ## Returns
    {:pagination_initialized, assigns}

  ## Example
      {:pagination_initialized, pagination_assigns} =
        PaginationHelpers.init(options, count_all, pagination_context)
  """
  def init(options, count_all, context) do
    per_page = Map.get(options, :per_page, context.default_per_page)
    count_visible_rows = min(count_all, per_page)

    pagination_assigns = %{
      pagination_context: context,
      count_all: count_all,
      count_all_summary: count_all,
      count_all_pagination: count_all,
      count_visible_rows: count_visible_rows,
      pending_deletion: false
    }

    {:pagination_initialized, pagination_assigns}
  end

  @doc """
  Applies pagination changes based on incoming parameters and determines if data needs to be reloaded.

  ## Parameters
    - `options` (map): The current pagination options (e.g., `%{page: 1, per_page: 10}`)
    - `params` (map): Potential new parameters from the URL or an event (may contain `"page"` or `"per_page"`)
    - `count_all` (integer): Total number of items for pagination (used to compute max page)
    - `context` (%Context{}): A struct holding pagination config (like `default_per_page`, `per_page_options`)
    - `force_reset` (boolean): If `true`, skips normal checks and signals a forced reload

  ## Returns
  One of:
    ```
    {:reset_stream, valid_options, page_changed, new_assigns}
    {:noreset_stream, valid_options}
    ```

  Where:
    - `:reset_stream` indicates data needs to be reloaded
    - `:noreset_stream` indicates current data can be kept
    - `valid_options` contains validated pagination options
    - `page_changed` is true if the page number was modified
    - `new_assigns` contains updated count and state values

  Stream reset occurs if:
    - force_reset is true
    - page/per_page values changed
    - requested page was adjusted to be in valid range

  ## Example
      case PaginationHelpers.apply_options(options, params, count_all, context, false) do
        {:reset_stream, valid_options, page_changed, pagination_assigns} ->
          # Re-fetch data, reset stream, push patch if page_changed
        {:noreset_stream, valid_options} ->
          # Keep using existing data
      end
  """
  def apply_options(options, params, count_all, context, force_reset) do
    old_page = Map.get(options, :page, 1)
    old_per_page = Map.get(options, :per_page, context.default_per_page)

    page = to_integer(params["page"] || old_page, 1)
    per_page = to_integer(params["per_page"] || old_per_page, context.default_per_page)
    new_options = Map.merge(options, %{page: page, per_page: per_page})
    valid_options = validate_options(new_options, count_all, context)

    reload_needed = force_reset or valid_options != options or valid_options.page != page
    page_changed = valid_options.page != page

    if reload_needed do
      count_visible_rows = min(count_all, per_page)

      new_assigns = %{
        count_all_summary: count_all,
        count_all_pagination: count_all,
        count_visible_rows: count_visible_rows,
        pending_deletion: false
      }

      {:reset_stream, valid_options, page_changed, new_assigns}
    else
      {:noreset_stream, valid_options}
    end
  end

  @doc """
  Updates pagination options with new per_page value from params.

  Extracts "per_page" parameter and converts it to integer. If param is missing or
  invalid, falls back to context.default_per_page value.

  ## Parameters
    - `options` - Current pagination options map
    - `params` - Request params that may contain "per_page"
    - `context` - Context with default_per_page fallback value

  ## Returns
    Updated options map with new :per_page value

  ## Example
      options = update_per_page_option(options, %{"per_page" => "20"}, context)
      options.per_page #=> 20
  """
  def update_per_page_option(options, params, context) do
    per_page = to_integer(Map.get(params, "per_page"), context.default_per_page)
    %{options | per_page: per_page}
  end

  @doc """
  Processes a newly created item by updating pagination counts and marking the item.

  Increments count fields in assigns:
  - :count_all
  - :count_all_summary
  - :count_visible_rows

  Also marks the item as newly created by setting :created flag.

  ## Parameters
    - `assigns`: Current assigns containing pagination count fields
    - `item`: The newly created item to process

  ## Returns
    Tuple `{:handled_created, assigns, item}` where:
    - assigns: Map with incremented pagination counts
    - item: Original item with :created flag set to true

  ## Example
      {:handled_created, new_assigns, marked_item} =
        PaginationHelpers.handle_created(socket.assigns, item)
  """
  def handle_created(assigns, item) do
    marked_item = Map.put(item, :created, true)

    new_assigns = %{
      count_all: assigns.count_all + 1,
      count_all_summary: assigns.count_all_summary + 1,
      count_visible_rows: assigns.count_visible_rows + 1
    }

    {:handled_created, new_assigns, marked_item}
  end

  @doc """
  Processes an updated item by marking it with :updated flag.

  Marks the item as updated by setting :updated flag. Unlike handle_created,
  no pagination counts need to be modified since this is updating an existing
  item.

  ## Parameters
    - `item`: The item being updated to process

  ## Returns
    Tuple `{:handled_updated, marked_item}` where:
    - marked_item: Original item with :updated flag set to true

  ## Example
      {:handled_updated, marked_item} =
        PaginationHelpers.handle_updated(item)
  """
  def handle_updated(item) do
    marked_item = Map.put(item, :updated, true)
    {:handled_updated, marked_item}
  end

  @doc """
  Processes a deleted item by updating pagination counts, marking it deleted and setting pending deletion state.

  - Decrements count_all field in assigns
  - Marks the item as deleted by setting :deleted flag
  - Sets :pending_deletion state in assigns to true to indicate deletion is in progress.

  ## Parameters
    - `assigns`: Current assigns containing pagination count fields
    - `item`: The item being deleted to process

  ## Returns
    Tuple `{:handled_deleted, assigns, item}` where:
    - assigns: Map with decremented pagination counts and pending_deletion flag
    - item: Original item with :deleted flag set to true

  ## Example
      {:handled_deleted, new_assigns, marked_item} =
        PaginationHelpers.handle_deleted(socket.assigns, item)
  """
  def handle_deleted(assigns, item) do
    marked_item = Map.put(item, :deleted, true)

    new_assigns = %{
      count_all: max(assigns.count_all - 1, 0),
      pending_deletion: true
    }

    {:handled_deleted, new_assigns, marked_item}
  end

  @doc """
  Produces a summary string describing the currently displayed items range.

  ## Parameters
    - `count_all` (integer): Total number of items in the collection
    - `page` (integer): Current page number
    - `per_page` (integer): Number of items displayed per page
    - `stream_size` (integer): Number of items currently visible in the stream

  ## Returns
    String in the format "Showing X - Y of Z" where:
      - X is the index of first item on current page
      - Y is the index of last visible item
      - Z is the total number of items

  ## Example
      iex> get_summary(100, 2, 10, 10)
      "Showing 11 - 20 of 100."
  """
  def get_summary(count_all, page, per_page, stream_size) do
    start = (page - 1) * per_page + 1
    ending = min(start + stream_size - 1, count_all)
    "Showing #{start} - #{ending} of #{count_all}."
  end
end
