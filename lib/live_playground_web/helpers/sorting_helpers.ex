defmodule LivePlaygroundWeb.SortingHelpers do
  @moduledoc """
  Provides a suite of functions and a configurable `Context` struct for handling
  sorting logic in Phoenix LiveView modules.
  """

  import Phoenix.Component

  defmodule Context do
    @moduledoc """
    A configuration struct that defines sorting behavior and constraints.

    Fields:
      - `sort_by`: The default field to sort by (atom)
      - `sort_order`: The default sort order (atom)
      - `allowed_sort_fields`: List of allowed fields for sorting
      - `allowed_orders`: List of allowed sort orders (default: [:asc, :desc])
      - `asc_indicator`: String indicator for ascending order (default: "↑")
      - `desc_indicator`: String indicator for descending order (default: "↓")
    """
    defstruct sort_by: nil,
              sort_order: :asc,
              allowed_sort_fields: [],
              allowed_orders: [:asc, :desc],
              asc_indicator: "↑",
              desc_indicator: "↓"
  end

  @doc """
  Converts sorting parameters to atoms and merges them into options map.

  ## Parameters
    - `options`: Target options map to merge sorting values into
    - `params`: Request parameters that may contain "sort_by" and "sort_order" strings
    - `context`: Sorting context containing defaults

  ## Returns
    Options map with :sort_by and :sort_order atoms, either:
    - Converted from params if present and valid
    - Or set to defaults from context
  """
  def convert_params(
        options,
        %{"sort_by" => sort_by, "sort_order" => sort_order} = _params,
        context
      ) do
    sort_by = to_atom_safe(sort_by, context.sort_by)
    sort_order = to_atom_safe(sort_order, context.sort_order)
    Map.merge(options, %{sort_by: sort_by, sort_order: sort_order})
  end

  def convert_params(options, _params, context) do
    Map.merge(options, %{sort_by: context.sort_by, sort_order: context.sort_order})
  end

  defp to_atom_safe(value, _fallback) when is_atom(value), do: value

  defp to_atom_safe(value, fallback) when is_binary(value) do
    try do
      String.to_existing_atom(value)
    rescue
      ArgumentError -> fallback
    end
  end

  defp to_atom_safe(_value, fallback), do: fallback

  @doc """
  Validates and adjusts sorting values to ensure they are within allowed options.

  If both :sort_by and :sort_order exist in options:
  - Ensures sort_by is one of the allowed fields from context
  - Ensures sort_order is one of the allowed orders
  - Updates options with corrected values

  If :sort_by or :sort_order are missing from options, returns options unchanged.

  ## Parameters
    - `options`: Map that may contain :sort_by and :sort_order atoms
    - `context`: Contains allowed_sort_fields and allowed_orders

  ## Returns
    Options map with either:
    - Validated/adjusted :sort_by and :sort_order values
    - Or unchanged if sorting keys were missing
  """
  def validate_options(%{sort_by: sort_by, sort_order: sort_order} = options, context) do
    sort_by = get_allowed_sort_field(sort_by, context)
    sort_order = get_allowed_sort_order(sort_order, context)
    %{options | sort_by: sort_by, sort_order: sort_order}
  end

  def validate_options(options, _context) do
    options
  end

  defp get_allowed_sort_field(sort_by, context) do
    if sort_by in context.allowed_sort_fields, do: sort_by, else: context.sort_by
  end

  defp get_allowed_sort_order(sort_order, context) do
    if sort_order in context.allowed_orders, do: sort_order, else: context.sort_order
  end

  @doc """
  Initializes sorting assigns with the provided context.

  Sets up initial sorting state with the context containing default values and constraints.
  This should be called during LiveView mount to establish the base sorting configuration.

  ## Parameters
    - `context` - Sorting context struct containing defaults and allowed values

  ## Returns
    Tuple `{:sorting_initialized, assigns}` where assigns contains:
    - :pagination_context - The provided sorting context

  ## Example
      {:sorting_initialized, sorting_assigns} =
        SortingHelpers.init(sorting_context)
  """
  def init(context) do
    sorting_assigns = %{
      pagination_context: context
    }

    {:sorting_initialized, sorting_assigns}
  end

  @doc """
  Applies sorting changes based on incoming parameters and determines if data needs to be reloaded.

  Processes new sorting parameters, validates them against allowed values, and determines
  if the changes require a stream reset. This is typically called when handling sorting
  parameter changes from URL or user interactions.

  ## Parameters
    - `options` (map): The current sorting options (e.g., `%{sort_by: :name, sort_order: :asc}`)
    - `params` (map): Potential new parameters (may contain `"sort_by"` or `"sort_order"`)
    - `context` (%Context{}): Sorting configuration with allowed values and defaults
    - `force_reset` (boolean): If `true`, skips normal checks and signals a forced reload

  ## Returns
  One of:
    ```
    {:reset_stream, valid_options, new_assigns}
    {:noreset_stream, valid_options}
    ```

  Where:
    - `:reset_stream` indicates data needs to be reloaded
    - `:noreset_stream` indicates current data can be kept
    - `valid_options` contains validated sorting options
    - `new_assigns` contains updated sort state values

  Stream reset occurs if:
    - force_reset is true
    - sort field or order values changed

  ## Example
      case SortingHelpers.apply_options(options, params, context, false) do
        {:reset_stream, valid_options, sorting_assigns} ->
          # Re-fetch data and reset stream with new sort options
        {:noreset_stream, valid_options} ->
          # Keep using existing data with current sort
      end
  """
  def apply_options(options, params, context, force_reset) do
    valid_options =
      options
      |> convert_params(params, context)
      |> validate_options(context)

    reload_needed = force_reset or valid_options != options

    if reload_needed do
      new_assigns = %{
        sort_by: valid_options.sort_by,
        sort_order: valid_options.sort_order
      }

      {:reset_stream, valid_options, new_assigns}
    else
      {:noreset_stream, valid_options}
    end
  end

  @doc """
  Generates a sorting link with appropriate indicators for the current sort state.

  Creates an interactive link component that handles column sorting. The link displays
  the current sort state using indicators (↑/↓) and generates the URL for the next
  sort state when clicked.

  ## Parameters
    - `label` - The text to display in the link
    - `col` - The column identifier (atom) this link sorts by
    - `options` - Map containing sorting options including :sort_by and :sort_order
    - `context` - Map containing sorting context including :fetch_url_fn

  ## Returns
    A Phoenix.Component link containing:
    - The provided label text
    - Sort indicator if this column is currently sorted
    - URL that will toggle sort order if clicked

  ## Example
      sort_link("Name", :name, %{sort_by: :name, sort_order: :asc}, context)
      # Renders link with "Name ↑" that will switch to descending when clicked
  """
  def sort_link(label, col, options, context) do
    sort_order_indicator = get_sort_order_indicator(col, options, context)
    sort_order_reversed = get_sort_order_reversed(col, options)

    new_options = Map.merge(options, %{sort_by: col, sort_order: sort_order_reversed})
    to = context.fetch_url_fn.(new_options)

    assigns = %{label: label, indicator: sort_order_indicator, to: to}

    ~H"""
    <.link patch={@to} class="flex gap-x-1">
      <span>{@label}</span>
      <span>{@indicator}</span>
    </.link>
    """
  end

  defp get_sort_order_indicator(col, options, context) when col == options.sort_by do
    case options.sort_order do
      :asc -> context.asc_indicator
      :desc -> context.desc_indicator
    end
  end

  defp get_sort_order_indicator(_, _, _), do: ""

  defp get_sort_order_reversed(col, options) when col == options.sort_by do
    case options.sort_order do
      :asc -> :desc
      :desc -> :asc
    end
  end

  defp get_sort_order_reversed(_, _), do: :asc
end
