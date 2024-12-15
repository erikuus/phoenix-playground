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
      - `sort_by`: The default/current field to sort by (atom)
      - `sort_order`: The default/current sort order (atom, `:asc` or `:desc`)
      - `fetch_url_fn`: A function that takes sorting options and returns a URL
      - `allowed_sort_fields`: A list of atoms representing allowed fields for sorting
      - `allowed_orders`: A list of atoms (e.g., `:asc`, `:desc`) representing allowed sort orders
      - `asc_indicator`: String indicator for ascending order (default: "↑")
      - `desc_indicator`: String indicator for descending order (default: "↓")
    """
    defstruct [
      :sort_by,
      :sort_order,
      :fetch_url_fn,
      :allowed_sort_fields,
      allowed_orders: [:asc, :desc],
      asc_indicator: "↑",
      desc_indicator: "↓"
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
    context = socket.assigns.sorting_context
    sort_by = to_atom_safe(sort_by, context.sort_by)
    sort_order = to_atom_safe(sort_order, context.sort_order)
    Map.merge(options, %{sort_by: sort_by, sort_order: sort_order})
  end

  def convert_params(options, socket, _params) do
    context = socket.assigns.sorting_context
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
  Applies sorting options to the socket based on URL parameters for the index action.
  This function processes the parameters through conversion and validation before
  updating the socket's options assign.

  ## Parameters
    - `socket`: The LiveView socket containing current state and sorting context
    - `:index`: Atom indicating this is for the index action
    - `params`: URL parameters that may contain "sort_by" and "sort_order"

  ## Returns
    The socket with updated sorting options in its assigns
  """
  def apply_options(socket, :index, params) do
    options =
      socket.assigns.options
      |> convert_params(socket, params)
      |> validate_options(socket)

    assign(socket, :options, options)
  end

  def apply_options(socket, _, _), do: socket

  @doc """
  Generates a sorting link with appropriate indicators for the current sort state.

  ## Parameters
    - `label` - The text to display in the link
    - `col` - The column identifier (atom) this link sorts by
    - `options` - Map containing sorting options including :sort_by and :sort_order
    - `context` - Map containing sorting context including :fetch_url_fn

  ## Returns
    A Phoenix.Component link containing the label text with sort indicators and URL for the next sort state
  """
  def sort_link(label, col, options, context) do
    sort_order_indicator = get_sort_order_indicator(col, options, context)
    sort_order_reversed = get_sort_order_reversed(col, options)

    new_options = Map.merge(options, %{sort_by: col, sort_order: sort_order_reversed})
    to = context.fetch_url_fn.(new_options)

    assigns = %{label: label, indicator: sort_order_indicator, to: to}

    ~H"""
    <.link patch={@to} class="flex gap-x-1">
      <span><%= @label %></span>
      <span><%= @indicator %></span>
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
