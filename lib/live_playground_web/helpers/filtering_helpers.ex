defmodule LivePlaygroundWeb.FilteringHelpers do
  @moduledoc """
  Provides a suite of functions and configurable structs for handling
  filtering logic in Phoenix LiveView modules.
  """

  defmodule FilterField do
    @moduledoc """
    Defines the configuration and validation rules for a single filter field.

    Fields:
      - `type`: The expected data type (:string, :boolean, :integer, etc.)
      - `default`: Default value when param is missing or invalid
      - `validate`: Validation rule, one of:
          * {:in, list} - value must be in the given list
          * {:custom, fun} - custom validation function that takes value and returns {:ok, value} or :error

    ## Examples
        %FilterField{
          type: :boolean,
          default: "false",
          validate: {:in, ["true", "false"]}
        }

        %FilterField{
          type: :integer,
          default: 0,
          validate: {:custom, &(&1 >= 0 && &1 <= 100)}
        }
    """
    defstruct [:type, :default, :validate, :convert]
  end

  defmodule Context do
    @moduledoc """
    A configuration struct that defines filtering behavior and constraints.

    Fields:
      - `fields`: Map of field names to their FilterField configurations

    ## Example
        %Context{
          fields: %{
            name: %FilterField{type: :string, default: ""},
            size: %FilterField{
              type: :string,
              default: "small",
              validate: {:in, ["small", "medium", "large"]}
            }
          }
        }
    """
    defstruct fields: %{}
  end

  @doc """
  Converts filtering parameters to their appropriate types.

  ## Parameters
    - `options`: Target options map
    - `params`: Request parameters from URL or form
    - `context`: Filtering context with field configurations

  ## Returns
    Options map with :filter key containing converted values

  ## Type Conversion Rules
    - Missing parameters → `""` (empty string)
    - Empty strings stay as empty strings
    - Invalid integers → `nil`
    - Invalid booleans → `nil`
    - Valid values → Appropriate type (integer, boolean, string)

  ## Note
    Used as the first step in the filtering pipeline. The converted values
    can be compared with validated values to determine if URL redirection is needed.

  ## Examples
    convert_params(%{}, %{"size" => "large", "count" => "42"}, context)
    #=> %{filter: %{"size" => "large", "count" => 42}}

    convert_params(%{}, %{"size" => ""}, context)
    #=> %{filter: %{"size" => ""}}

    convert_params(%{}, %{"count" => "abc"}, context)
    #=> %{filter: %{"count" => nil}}
  """
  def convert_params(%{filter: _} = options, %{} = params, _context) when params == %{} do
    options
  end

  def convert_params(options, params, context) do
    filter =
      context.fields
      |> Enum.reduce(%{}, fn {field, config}, acc ->
        field_string = to_string(field)

        value =
          params
          |> Map.get(field_string)
          |> convert_value(config)

        Map.put(acc, field_string, value)
      end)

    Map.put(options, :filter, filter)
  end

  defp convert_value(nil, _), do: ""

  defp convert_value(value, %FilterField{type: :integer}) when is_binary(value) do
    case Integer.parse(value) do
      {int, ""} -> int
      _ -> nil
    end
  end

  defp convert_value(value, %FilterField{type: :boolean}) when is_binary(value) do
    case value do
      "true" -> true
      "false" -> false
      _ -> nil
    end
  end

  defp convert_value(value, _), do: value

  @doc """
  Applies default values to empty filter parameters.

  ## Parameters
    - `options`: Options map containing converted filter values
    - `context`: Filtering context with default values

  ## Returns
    Options map with defaults applied to empty strings

  ## Rules
    - Empty strings (`""`) → Field's default value ONLY if default is not empty
    - Other values including `nil` are preserved as-is
    - If options has no filter key, returns options unchanged

  ## Note
    Used as an intermediate step in the filtering pipeline, after conversion
    but before validation.

  ## Examples
    # Empty strings receive non-empty defaults
    apply_defaults(
      %{filter: %{"size" => "", "count" => 42}},
      %Context{fields: %{size: %FilterField{default: "medium"}}}
    )
    #=> %{filter: %{"size" => "medium", "count" => 42}}

    # nil values from failed conversions are preserved
    apply_defaults(
      %{filter: %{"size" => "", "count" => nil}},
      %Context{fields: %{size: %FilterField{default: "medium"}, count: %FilterField{default: 0}}}
    )
    #=> %{filter: %{"size" => "medium", "count" => nil}}
  """
  def apply_defaults(%{filter: filter} = options, context) do
    filter_with_defaults =
      context.fields
      |> Enum.reduce(%{}, fn {field, config}, acc ->
        field_string = to_string(field)

        value =
          filter
          |> Map.get(field_string)
          |> apply_default(config)

        Map.put(acc, field_string, value)
      end)

    %{options | filter: filter_with_defaults}
  end

  def apply_defaults(options, _context), do: options

  # Only apply non-empty defaults to empty strings
  defp apply_default("", %FilterField{default: default}) when default != "", do: default
  defp apply_default(value, _), do: value

  @doc """
  Validates filter values against their field configurations.

  ## Parameters
    - `options`: Map containing :filter with converted values
    - `context`: Filtering context with validation rules

  ## Returns
    Options map with validated filter values:
    - Valid values are preserved
    - Invalid values (including nil) are replaced with empty strings ("")

  ## Note
    Final step in the filtering pipeline. Validation standardizes invalid
    values (including nil) to empty strings, making them consistent with
    the URL generation logic that omits empty values. The comparison between
    converted options and validated options identifies cases requiring URL
    redirection.

  ## Examples
    # Valid filters
    validate_options(
      %{filter: %{size: "large"}},
      %Context{fields: %{size: %FilterField{validate: {:in, ["small", "medium", "large"]}}}}
    )
    #=> %{filter: %{size: "large"}}

    # Invalid filters (replaced with empty strings)
    validate_options(
      %{filter: %{size: "invalid"}},
      %Context{fields: %{size: %FilterField{validate: {:in, ["small", "medium", "large"]}}}}
    )
    #=> %{filter: %{size: ""}}
  """
  def validate_options(%{filter: filter} = options, context) do
    valid_filter =
      context.fields
      |> Enum.reduce(%{}, fn {field, config}, acc ->
        field_string = to_string(field)

        value =
          filter
          |> Map.get(field_string)
          |> validate_value(config)

        Map.put(acc, field_string, value)
      end)

    %{options | filter: valid_filter}
  end

  def validate_options(options, _context), do: options

  defp validate_value(nil, _config), do: ""

  defp validate_value(value, %FilterField{validate: {:in, allowed_values}}) do
    if value in allowed_values, do: value, else: ""
  end

  defp validate_value(value, %FilterField{validate: {:custom, validate_fn}}) do
    case validate_fn.(value) do
      {:ok, valid_value} -> valid_value
      :error -> ""
    end
  end

  defp validate_value(value, _config), do: value

  @doc """
  Initializes filtering assigns with the provided context.

  ## Parameters
    - `context`: Filtering configuration containing field definitions and validation rules

  ## Returns
    Tuple `{:filtering_initialized, assigns}` where assigns contains:
    - :filtering_context - The provided filtering configuration

  ## Examples
      {:filtering_initialized, assigns} = FilteringHelpers.init_filtering(filtering_context)
  """
  def init_filtering(context) do
    {:filtering_initialized, %{filtering_context: context}}
  end

  @doc """
  Resolves filtering changes and determines if data needs to be reloaded.

  Processes filter parameters through a pipeline that:
  1. Converts values to appropriate types
  2. Validates against field configurations
  3. Checks if changes require a data reload

  ## Parameters
    - `options` (map): The current filter options
    - `params` (map): Potential new filter parameters
    - `context` (%Context{}): Filtering configuration
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
    - `valid_options` contains validated filter options

  Stream reset occurs if:
    - force_reset is true
    - filter values change after conversion or validation

  ## Example
      case FilteringHelpers.resolve_filtering_changes(options, params, context, false) do
        {:reset_stream, valid_options} ->
          # Re-fetch data and reset stream with new filter options
        {:noreset_stream, valid_options} ->
          # Keep using existing data with current filter
      end
  """
  def resolve_filtering_changes(options, params, context, force_reset) do
    valid_options =
      options
      |> convert_params(params, context)
      |> validate_options(context)

    if force_reset or valid_options != options do
      {:reset_stream, valid_options}
    else
      {:noreset_stream, valid_options}
    end
  end

  @doc """
  Updates and converts filter options from params.

  ## Parameters
    - `options` (map): The current options map that may contain existing filter values
    - `params` (map): Request parameters containing potential filter values
    - `context` (%Context{}): Filtering context containing allowed field definitions

  ## Returns
    Options map with updated :filter key containing converted param values for fields
    defined in context. Values are converted but not validated at this stage.

  ## Examples
      # Update and convert filter with new params
      options = %{filter: %{"language" => "eng"}}
      params = %{"language" => "spa", "isofficial" => "true", "percentage" => "42"}
      FilteringHelpers.update_filter_options(options, params, context)
      #=> %{filter: %{"language" => "spa", "isofficial" => "true", "percentage" => 42}}

      # Empty or missing params preserved and converted
      options = %{filter: %{"language" => ""}}
      params = %{"language" => "", "percentage" => "invalid"}
      FilteringHelpers.update_filter_options(options, params, context)
      #=> %{filter: %{"language" => "", "percentage" => ""}}
  """
  def update_filter_options(options, params, context) do
    filter =
      context.fields
      |> Enum.reduce(%{}, fn {field, config}, acc ->
        field_string = to_string(field)

        value =
          params
          |> Map.get(field_string)
          |> convert_value(config)

        Map.put(acc, field_string, value)
      end)

    %{options | filter: filter}
  end
end
