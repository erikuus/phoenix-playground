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
  Converts pagination parameters to integers and determines the source of pagination values.

  ## Parameters
    - `options`: Target options map that may contain existing pagination values
    - `params`: Request parameters that may contain "page" and "per_page" strings
    - `context`: Pagination context containing defaults

  ## Returns
    Options map with :page and :per_page integers, sourced from either:
    - params if pagination parameters are present
    - existing options if they contain valid pagination fields
    - default values (0) if neither params nor options have pagination fields

  ## Conversion Details
    - Valid integer params are converted to their integer values
    - Invalid or missing values are converted to 0 (not context.default_per_page)
    - This intentionally creates invalid values that will be corrected during validation
    - The difference between converted and validated values triggers URL synchronization

  ## URL Synchronization
    Using 0 as default ensures that:
    1. Invalid URL parameters (like 'page=abc') are properly rewritten
    2. Out-of-range values (like 'page=1000') are corrected to valid limits
    3. Missing parameters receive proper defaults in the URL

  ## Examples
      # From params
      PaginationHelpers.convert_params(%{}, %{"page" => "2", "per_page" => "20"}, context)
      #=> %{page: 2, per_page: 20}

      # From invalid params (will be fixed in validation)
      PaginationHelpers.convert_params(%{}, %{"page" => "abc"}, context)
      #=> %{page: 0, per_page: context.default_per_page}

      # From existing options
      PaginationHelpers.convert_params(%{page: 2, per_page: 20}, %{}, context)
      #=> %{page: 2, per_page: 20}

      # From empty params (will be fixed in validation)
      PaginationHelpers.convert_params(%{}, %{}, context)
      #=> %{page: 0, per_page: 0}
  """
  def convert_params(options, %{"page" => page, "per_page" => per_page} = _params) do
    page = to_integer(page, 0)
    per_page = to_integer(per_page, 0)
    Map.merge(options, %{page: page, per_page: per_page})
  end

  def convert_params(options, %{"page" => page} = _params) do
    page = to_integer(page, 0)
    per_page = 0
    Map.merge(options, %{page: page, per_page: per_page})
  end

  def convert_params(options, %{"per_page" => per_page} = _params) do
    page = 0
    per_page = to_integer(per_page, 0)
    Map.merge(options, %{page: page, per_page: per_page})
  end

  def convert_params(%{page: _, per_page: _} = options, _params) do
    options
  end

  def convert_params(options, _params) do
    Map.merge(options, %{page: 0, per_page: 0})
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
  Converts pagination parameters to integers and determines the source of pagination values.

  ## Parameters
    - `options`: Target options map that may contain existing pagination values
    - `params`: Request parameters that may contain "page" and "per_page" strings

  ## Returns
    Options map with :page and :per_page integers, sourced from either:
    - params if pagination parameters are present
    - existing options if they contain valid pagination fields
    - default values (0) if neither params nor options have pagination fields

  ## Conversion Details
    - Valid integer params are converted to their integer values
    - Invalid or missing values are converted to 0
    - This intentionally creates invalid values that will be corrected during validation
    - The difference between converted and validated values triggers URL synchronization

  ## Examples
      # From params
      PaginationHelpers.convert_params(%{}, %{"page" => "2", "per_page" => "20"})
      #=> %{page: 2, per_page: 20}

      # From invalid params (will be fixed in validation)
      PaginationHelpers.convert_params(%{}, %{"page" => "abc"})
      #=> %{page: 0, per_page: 0}

      # From partial params
      PaginationHelpers.convert_params(%{}, %{"page" => "2"})
      #=> %{page: 2, per_page: 0}

      # From existing options
      PaginationHelpers.convert_params(%{page: 2, per_page: 20}, %{})
      #=> %{page: 2, per_page: 20}

      # From empty params (will be fixed in validation)
      PaginationHelpers.convert_params(%{}, %{})
      #=> %{page: 0, per_page: 0}
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
    # Use max to ensure per_page is at least 1 to avoid division by zero
    safe_per_page = max(per_page, 1)
    max_page = ceil_div(count_all, safe_per_page)

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
  Initializes pagination assigns with counts and state flags.

  ## Parameters
    - `options`: Current pagination options (uses :per_page if present)
    - `count_all`: Total number of items in the collection
    - `context`: Pagination context for default_per_page value

  ## Returns
    Tuple `{:pagination_initialized, assigns}` where assigns contains:
    - :pagination_context - Configuration for pagination behavior
    - :count_all - Base count for pagination calculations
    - :count_all_summary - Count for summary display
    - :count_all_pagination - Count for pagination controls
    - :count_visible_rows - Number of rows visible on current page
    - :pending_deletion - Flag for deletion in progress
    - :visible_ids - List of IDs for items currently visible on the page (starts empty,
      populated by LiveView after fetching data)

  ## Example
      {:pagination_initialized, assigns} = PaginationHelpers.init_pagination(
        %{per_page: 10},  # existing options
        42,               # total items
        pagination_context
      )
  """
  def init_pagination(options, count_all, context) do
    per_page = Map.get(options, :per_page, context.default_per_page)
    count_visible_rows = min(count_all, per_page)

    pagination_assigns = %{
      pagination_context: context,
      count_all: count_all,
      count_all_summary: count_all,
      count_all_pagination: count_all,
      count_visible_rows: count_visible_rows,
      pending_deletion: false,
      visible_ids: []
    }

    {:pagination_initialized, pagination_assigns}
  end

  @doc """
  Resolves pagination changes and determines if data needs to be reloaded.

  Processes pagination parameters through a pipeline that:
  1. Converts params to obtain new pagination values
  2. Validates values against total count and allowed options
  3. Checks if changes require a data reload

  ## Parameters
    - `options` (map): The current pagination options (e.g., `%{page: 1, per_page: 10}`)
    - `params` (map): Potential new parameters (may contain `"page"` or `"per_page"`)
    - `count_all` (integer): Total number of items for pagination (used to compute max page)
    - `context` (%Context{}): Pagination configuration with defaults and constraints
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
    - `page_changed` is true if page number changed after conversion or validation
    - `new_assigns` contains updated count and state values, including:
      * count_all_summary
      * count_all_pagination
      * count_visible_rows
      * pending_deletion
      * visible_ids (reset to [] when stream needs reset, populated by LiveView after fetching new data)

  Stream reset occurs if:
    - force_reset is true
    - pagination values change after conversion or validation
    - requested page was adjusted during validation (e.g., exceeding max pages)

  ## Example
      case PaginationHelpers.resolve_pagination_changes(options, params, count_all, context, false) do
        {:reset_stream, valid_options, page_changed, new_assigns} ->
          # Re-fetch data, reset stream, push patch if page_changed
        {:noreset_stream, valid_options} ->
          # Keep using existing data with current sort
      end
  """
  def resolve_pagination_changes(options, params, count_all, context, force_reset) do
    new_options = convert_params(options, params)
    valid_options = validate_options(new_options, count_all, context)

    reset_needed =
      force_reset or valid_options != options or valid_options.page != new_options.page

    page_changed = valid_options.page != new_options.page

    if reset_needed do
      count_visible_rows = min(count_all, valid_options.per_page)

      new_assigns = %{
        count_all_summary: count_all,
        count_all_pagination: count_all,
        count_visible_rows: count_visible_rows,
        pending_deletion: false,
        visible_ids: []
      }

      {:reset_stream, valid_options, page_changed, new_assigns}
    else
      {:noreset_stream, valid_options}
    end
  end

  @doc """
  Updates pagination options with new per_page value from params.

  ## Parameters
    - `options`: Current pagination options map (must contain :per_page)
    - `params`: Request params that may contain "per_page"
    - `context`: Context with default_per_page and per_page_options

  ## Returns
    Updated options map with new :per_page value, either:
    - Converted from params if present and valid
    - Or using context.default_per_page as fallback

  ## Example
      options = %{page: 2, per_page: 10}
      params = %{"per_page" => "20"}
      PaginationHelpers.update_per_page_option(options, params, context)
      #=> %{page: 2, per_page: 20}
  """
  def update_per_page_option(options, params, context) do
    per_page = to_integer(Map.get(params, "per_page"), context.default_per_page)
    %{options | per_page: per_page}
  end

  @doc """
  Processes a newly created item by updating counts and marking creation state.

  ## Parameters
    - `assigns`: Current assigns containing count fields
    - `item`: Item being created

  ## Returns
    Tuple `{:processed_created, assigns, item}` where:
    - assigns: Contains incremented counts and updated visible_ids:
      * count_all + 1
      * count_all_summary + 1
      * count_visible_rows + 1
      * visible_ids with new item.id prepended
    - item: Has :created = true flag set

  ## Example
      {:processed_created,
       %{count_all: 43,
         count_all_summary: 43,
         count_visible_rows: 11,
         visible_ids: [1, 2, 3]},
       %{id: 1, created: true}} =
        PaginationHelpers.process_created(
          %{count_all: 42,
            count_all_summary: 42,
            count_visible_rows: 10,
            visible_ids: [2, 3]},
          %{id: 1}
        )
  """
  def process_created(assigns, item) do
    marked_item = Map.put(item, :created, true)

    new_assigns = %{
      count_all: assigns.count_all + 1,
      count_all_summary: assigns.count_all_summary + 1,
      count_visible_rows: assigns.count_visible_rows + 1,
      visible_ids: [item.id | assigns.visible_ids]
    }

    {:processed_created, new_assigns, marked_item}
  end

  @doc """
  Processes an updated item by marking update state.

  ## Parameters
    - `item`: Item being updated

  ## Returns
    Tuple `{:processed_updated, item}` where:
    - item: Has :updated = true flag set

  ## Example
      {:processed_updated, %{id: 1, updated: true}} =
        PaginationHelpers.process_updated(%{id: 1})
  """
  def process_updated(item) do
    marked_item = Map.put(item, :updated, true)
    {:processed_updated, marked_item}
  end

  @doc """
  Processes a deleted item by updating counts and marking deletion state.

  ## Parameters
    - `assigns`: Current assigns containing count fields
    - `item`: Item being deleted

  ## Returns
    Tuple `{:processed_deleted, assigns, item}` where:
    - assigns: Contains decremented :count_all and :pending_deletion = true
    - item: Has :deleted = true flag set

  ## Example
      {:processed_deleted, %{count_all: 41, pending_deletion: true}, %{id: 1, deleted: true}} =
        PaginationHelpers.process_deleted(%{count_all: 42}, %{id: 1})
  """
  def process_deleted(assigns, item) do
    marked_item = Map.put(item, :deleted, true)

    new_assigns = %{
      count_all: max(assigns.count_all - 1, 0),
      pending_deletion: true
    }

    {:processed_deleted, new_assigns, marked_item}
  end

  @doc """
  Produces a summary string describing the currently displayed items range.

  ## Parameters
    - `count_all`: Total number of items in collection
    - `page`: Current page number (starting from 1)
    - `per_page`: Number of items per page
    - `stream_size`: Actual number of items currently in view. This may temporarily
      differ from per_page during operations like additions before refresh.

  ## Returns
    One of:
    - "No items to display." when collection is empty (count_all = 0)
    - "No items match your filter." when filtering returns no results (stream_size = 0)
    - "Showing X - Y of Z." where:
      * X is the index of first item ((page - 1) * per_page + 1)
      * Y is the actual last item index (min(start + stream_size - 1, count_all))
      * Z is the total count

  ## Examples
      # Normal page display
      PaginationHelpers.get_summary(100, 1, 5, 5)
      #=> "Showing 1 - 5 of 100."

      # After item addition, before refresh
      PaginationHelpers.get_summary(101, 1, 5, 6)
      #=> "Showing 1 - 6 of 101."  # stream_size temporarily 6

      # Empty collection
      PaginationHelpers.get_summary(0, 1, 5, 0)
      #=> "No items to display."

      # Filtered with no matches
      PaginationHelpers.get_summary(100, 1, 5, 0)
      #=> "No items match your filter."
  """
  def get_summary(count_all, page, per_page, stream_size) do
    cond do
      count_all == 0 ->
        "No items to display."

      stream_size == 0 ->
        "No items match your filter."

      true ->
        start = (page - 1) * per_page + 1
        ending = min(start + stream_size - 1, count_all)
        "Showing #{start} - #{ending} of #{count_all}."
    end
  end
end
