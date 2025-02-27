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
  Converts filtering parameters to their appropriate types and applies defaults.

  ## Parameters
    - `options`: Target options map that may contain existing filter values
    - `params`: Request parameters containing potential filter values
    - `context`: Filtering context containing field configurations

  ## Returns
    Options map with :filter key containing converted and defaulted values

  ## Examples
      # With valid params
      convert_params(%{}, %{"size" => "large"}, context)
      #=> %{filter: %{size: "large"}}

      # With invalid params (falls back to defaults)
      convert_params(%{}, %{"size" => "invalid"}, context)
      #=> %{filter: %{size: "small"}}
  """
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

  defp convert_value("", _), do: ""
  defp convert_value(nil, _), do: ""

  defp convert_value(value, %FilterField{type: :integer}) when is_binary(value) do
    case Integer.parse(value) do
      {int, ""} -> int
      _ -> ""
    end
  end

  defp convert_value(value, %FilterField{type: :boolean}) when is_binary(value) do
    case value do
      "true" -> "true"
      "false" -> "false"
      _ -> ""
    end
  end

  defp convert_value(value, _), do: value

  @doc """
  Validates filter values against their field configurations.

  ## Parameters
    - `options`: Map containing :filter with converted values
    - `context`: Filtering context with validation rules

  ## Returns
    Options map with validated filter values, invalid values replaced with defaults

  ## Examples
      # Valid filters
      validate_options(
        %{filter: %{size: "large"}},
        %Context{fields: %{size: %FilterField{validate: {:in, ["small", "medium", "large"]}}}}
      )
      #=> %{filter: %{size: "large"}}

      # Invalid filters (replaced with defaults)
      validate_options(
        %{filter: %{size: "invalid"}},
        %Context{fields: %{size: %FilterField{default: "small", validate: {:in, ["small", "medium", "large"]}}}}
      )
      #=> %{filter: %{size: "small"}}
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

  defp validate_value(value, %FilterField{validate: {:in, allowed_values}} = config) do
    if value in allowed_values, do: value, else: config.default
  end

  defp validate_value(value, %FilterField{validate: {:custom, validate_fn}} = config) do
    case validate_fn.(value) do
      {:ok, valid_value} -> valid_value
      :error -> config.default
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
