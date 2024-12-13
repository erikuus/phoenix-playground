defmodule LivePlaygroundWeb.SortingHelpers do
  @moduledoc """
  Provides a suite of functions and a configurable `Context` struct for handling
  sorting logic in Phoenix LiveView modules.
  """

  import Phoenix.Component

  defmodule Context do
    @moduledoc """
    A configuration struct for sorting.

    Fields:
      - `allowed_sort_fields`: A list of atoms representing allowed fields for sorting
      - `allowed_orders`: A list of atoms (e.g., `:asc`, `:desc`) representing allowed sort orders
      - `sort_by`: The default/current field to sort by (atom)
      - `sort_order`: The default/current sort order (atom, `:asc` or `:desc`)
      - `fetch_url_fn`: A function that takes sorting options and returns a URL
      - `asc_indicator`: String indicator for ascending order (default: "▴")
      - `desc_indicator`: String indicator for descending order (default: "▾")
    """
    defstruct [
      :allowed_sort_fields,
      :allowed_orders,
      :sort_by,
      :sort_order,
      :fetch_url_fn,
      asc_indicator: "▴",
      desc_indicator: "▾"
    ]
  end

  @doc """
  Converts sorting parameters from string to atom values and merges them with existing options.

  ## Parameters
    - `options`: The existing sorting options map
    - `socket`: The LiveView socket with assigned `context`
    - `params`: A map of parameters from URL or user input containing "sort_by" and "sort_order"

  ## Returns
    A map `%{sort_by: atom, sort_order: atom}` with converted and merged sorting parameters
  """
  def convert_params(
        options,
        socket,
        %{"sort_by" => sort_by, "sort_order" => sort_order} = _params
      ) do
    context = socket.assigns.context
    sort_by = to_atom_safe(sort_by, context.sort_by)
    sort_order = to_atom_safe(sort_order, context.sort_order)
    Map.merge(options, %{sort_by: sort_by, sort_order: sort_order})
  end

  def convert_params(options, socket, _params) do
    context = socket.assigns.context
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
  Validates sorting options against the allowed fields and orders in the context.

  ## Parameters
    - `options`: The sorting options to validate containing sort_by and sort_order
    - `socket`: The LiveView socket with assigned `sorting_context`

  ## Returns
    A map with validated sort_by and sort_order values, reverting to context defaults if invalid
  """
  def validate_options(%{sort_by: sort_by, sort_order: sort_order} = options, socket) do
    context = socket.assigns.sorting_context
    sort_by = if sort_by in context.allowed_sort_fields, do: sort_by, else: context.sort_by
    sort_order = if sort_order in context.allowed_orders, do: sort_order, else: context.sort_order
    %{options | sort_by: sort_by, sort_order: sort_order}
  end

  def validate_options(options, _socket) do
    options
  end

  @doc """
  Generates a sorting link with appropriate indicators for the current sort state.

  ## Parameters
    - `label`: The text to display in the link
    - `col`: The column identifier (atom) this link sorts by
    - `socket`: The LiveView socket with assigned `sorting_context` and `sorting_options`

  ## Returns
    A Phoenix.Component link with sorting indicators and URL for the next sort state
  """
  def sort_link(label, col, socket) do
    context = socket.assigns.sorting_context
    options = socket.assigns.sorting_options

    sort_order_indicator = get_sort_order_indicator(col, options, context)
    sort_order_reversed = get_sort_order_reversed(col, options)

    new_options = Map.put(options, :sort_order, sort_order_reversed)
    to = context.fetch_url_fn.(new_options)

    assigns = %{label: label <> sort_order_indicator, to: to}

    ~H"""
    <.link patch={@to}>
      <%= @label %>
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
