defmodule LivePlaygroundWeb.SortingHelpers do
  @moduledoc """
  Provides a suite of functions and a configurable `Context` struct for handling
  sorting logic in Phoenix LiveView modules.
  """

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
  Converts sorting parameters to atoms and determines the source of sort values.

  ## Parameters
    - `options`: Target options map that may contain existing sort values
    - `params`: Request parameters that may contain "sort_by" and "sort_order" strings

  ## Returns
    Options map with :sort_by and :sort_order atoms, sourced from either:
    - params if sort parameters are present
    - existing options if they contain valid sort fields
    - placeholder values (:invalid) if neither params nor options have sort fields

  ## URL Synchronization
    Using :invalid as placeholder ensures that validation will detect and
    correct invalid values, triggering URL synchronization when needed.

  ## Examples
      # From params
      convert_params(%{}, %{"sort_by" => "name", "sort_order" => "asc"})
      #=> %{sort_by: :name, sort_order: :asc}

      # From invalid params (will be fixed in validation)
      convert_params(%{}, %{"sort_by" => "unknown_field"})
      #=> %{sort_by: :unknown_field, sort_order: :invalid}

      # From existing options
      convert_params(%{sort_by: :name, sort_order: :asc}, %{})
      #=> %{sort_by: :name, sort_order: :asc}

      # From empty params (will be fixed in validation)
      convert_params(%{}, %{})
      #=> %{sort_by: :invalid, sort_order: :invalid}
  """
  def convert_params(
        options,
        %{"sort_by" => sort_by, "sort_order" => sort_order} = _params
      ) do
    sort_by = to_atom_safe(sort_by, :invalid)
    sort_order = to_atom_safe(sort_order, :invalid)
    Map.merge(options, %{sort_by: sort_by, sort_order: sort_order})
  end

  def convert_params(
        options,
        %{"sort_by" => sort_by} = _params
      ) do
    sort_by = to_atom_safe(sort_by, :invalid)
    sort_order = :invalid
    Map.merge(options, %{sort_by: sort_by, sort_order: sort_order})
  end

  def convert_params(
        options,
        %{"sort_order" => sort_order} = _params
      ) do
    sort_by = :invalid
    sort_order = to_atom_safe(sort_order, :invalid)
    Map.merge(options, %{sort_by: sort_by, sort_order: sort_order})
  end

  def convert_params(%{sort_by: _, sort_order: _} = options, _params) do
    options
  end

  def convert_params(options, _params) do
    Map.merge(options, %{sort_by: :invalid, sort_order: :invalid})
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
  Validates sorting options against allowed values in context.

  ## Parameters
    - `options`: Map containing :sort_by and :sort_order from convert_params
    - `context`: Sorting context containing allowed_sort_fields and allowed_orders

  ## Returns
    Options map with validated values, where:
    - sort_by falls back to context.sort_by if not in allowed_sort_fields
    - sort_order falls back to context.sort_order if not in allowed_orders
    - original options returned unchanged if sorting keys missing

  ## Examples
      # Valid options
      validate_options(%{sort_by: :name, sort_order: :asc}, context)
      #=> %{sort_by: :name, sort_order: :asc}

      # Invalid sort_by
      validate_options(%{sort_by: :invalid, sort_order: :asc}, context)
      #=> %{sort_by: context.sort_by, sort_order: :asc}
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

  ## Parameters
    - `context`: Sorting configuration containing:
        - sort_by: Default field to sort by
        - sort_order: Default sort order (:asc/:desc)
        - allowed_sort_fields: List of valid sort fields
        - allowed_orders: List of valid sort orders
        - asc_indicator/desc_indicator: Sort direction indicators

  ## Returns
    Tuple `{:sorting_initialized, assigns}` where assigns contains:
    - :sorting_context - The provided sorting configuration

  ## Examples
      {:sorting_initialized, assigns} = SortingHelpers.init_sorting(sorting_context)
  """
  def init_sorting(context) do
    sorting_assigns = %{
      sorting_context: context
    }

    {:sorting_initialized, sorting_assigns}
  end

  @doc """
  Resolves sorting changes and determines if data needs to be reloaded.

  Processes sorting parameters through a pipeline that:
  1. Determines sort values from params, existing options, or context defaults
  2. Validates values against allowed fields and orders
  3. Checks if changes require a data reload

  ## Parameters
    - `options` (map): The current sorting options (e.g., `%{sort_by: :name, sort_order: :asc}`)
    - `params` (map): Potential new parameters (may contain `"sort_by"` or `"sort_order"`)
    - `context` (%Context{}): Sorting configuration with allowed values and defaults
    - `force_reset` (boolean): If `true`, skips normal checks and signals a forced reload

  ## Returns
  One of:
    ```
    {:reset_stream, valid_options}
    {:noreset_stream, valid_options}
    ```

  Where:
    - `:reset_stream` indicates data needs to be reloaded
    - `:noreset_stream` indicates current data can be kept
    - `valid_options` contains validated sorting options

  Stream reset occurs if:
    - force_reset is true
    - sort values change after conversion or validation
    - initial sort values are set from context defaults

  ## Example
      case SortingHelpers.resolve_sorting_changes(options, params, context, false) do
        {:reset_stream, valid_options} ->
          # Re-fetch data and reset stream with new sort options
        {:noreset_stream, valid_options} ->
          # Keep using existing data with current sort
      end
  """
  def resolve_sorting_changes(options, params, context, force_reset) do
    valid_options =
      options
      |> convert_params(params)
      |> validate_options(context)

    reset_needed = force_reset or valid_options != options

    if reset_needed do
      {:reset_stream, valid_options}
    else
      {:noreset_stream, valid_options}
    end
  end

  @doc ~S'''
  Generates sorting info for a column header link.

  ## Parameters
    - `label`: Display text for the column header
    - `col`: Column identifier (atom) this link sorts by
    - `options`: Current sorting state (%{sort_by: atom, sort_order: :asc/:desc})
    - `context`: Sorting configuration with asc_indicator/desc_indicator

  ## Returns
    Map containing:
    - :label - Column header text
    - :indicator - Current sort indicator ("↑"/"↓") or empty string
    - :options - Updated options for next sort state

  ## Example
      # In your LiveView:
      defp sort_link(label, col, options, context) do
        assigns = SortingHelpers.get_sort_link_assigns(label, col, options, context)
        ~H"""
        <.link patch={get_url(assigns.options)} class="flex gap-x-1">
          <span>{@label}</span>
          <span>{@indicator}</span>
        </.link>
        """
      end

      # In your template (.heex):
      <:col :let={{_id, name}} label={sort_link("Name", :name, @options, @sorting_context)}>
  '''
  def get_sort_link_assigns(label, col, options, context) do
    sort_order_indicator = get_sort_order_indicator(col, options, context)
    sort_order_reversed = get_sort_order_reversed(col, options)

    new_options = Map.merge(options, %{sort_by: col, sort_order: sort_order_reversed})

    %{
      label: label,
      indicator: sort_order_indicator,
      options: new_options
    }
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
