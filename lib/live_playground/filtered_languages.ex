defmodule LivePlayground.FilteredLanguages do
  @moduledoc """
  The FilteredLanguages context.
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.FilteredLanguages.Language

  @pubsub LivePlayground.PubSub
  @topic "languages"

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  def unsubscribe do
    Phoenix.PubSub.unsubscribe(@pubsub, @topic)
  end

  def broadcast({:ok, language}, event) do
    Phoenix.PubSub.broadcast_from(@pubsub, self(), @topic, {__MODULE__, {event, language}})

    {:ok, language}
  end

  def broadcast({:error, changeset}, _event) do
    {:error, changeset}
  end

  @doc """
    Counts languages that match the given filtering options.

    ## Parameters
      - `options`: Map containing filter criteria (defaults to an empty map)

    ## Returns
      Integer representing the count of matching languages

    ## Examples
        # Count all languages
        count_languages()
        #=> 984

        # Count languages with specific filters
        count_languages(%{filter: %{"countrycode" => "EST", "isofficial" => "true"}})
        #=> 1
  """
  def count_languages(options \\ %{}) do
    Language
    |> filter(options)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
    Determines if a language matches the specified filter options.

    ## Parameters
      - `language`: A Language struct or map containing a language ID
      - `options`: Map containing filter criteria (defaults to an empty map)

    ## Returns
      Boolean indicating whether language matches the filters

    ## Examples
        # Check if language matches country filter
        language = get_language!(1)
        matches_filter?(language, %{filter: %{"countrycode" => "EST"}})
        #=> true

        # Check if language matches multiple filters
        matches_filter?(language, %{filter: %{"isofficial" => "true", "percentage_min" => 50}})
        #=> false
  """
  def matches_filter?(language, options \\ %{}) do
    Language
    |> where([l], l.id == ^language.id)
    |> filter(options)
    |> Repo.exists?()
  end

  @doc """
  Fetches a filtered, paginated and sorted list of languages based on the provided options.

  ## Filtering
  - The `filter` option contains a map of field names to filter values
  - Supported filters: countrycode, language, isofficial, percentage_min, percentage_max

  ## Sorting
  - The `sort_by` option specifies the field to sort by
  - The `sort_order` option specifies the sort direction (`:asc` or `:desc`)

  ## Pagination
  - The `page` option specifies the page number (1-based)
  - The `per_page` option specifies the number of items per page

  ## Examples
      # Filter, sort and paginate
      list_languages(%{
        filter: %{
          countrycode: "EST",
          language: "est",
          percentage_min: 50
        },
        sort_by: :language,
        sort_order: :asc,
        page: 1,
        per_page: 10
      })
  """
  def list_languages(options \\ %{}) do
    Language
    |> filter(options)
    |> sort(options)
    |> paginate(options)
    |> Repo.all()
  end

  defp filter(query, %{filter: filters}) when is_map(filters) do
    Enum.reduce(filters, query, fn
      {"countrycode", value}, query when is_binary(value) ->
        from l in query,
          where: ilike(l.countrycode, ^"#{value}%")

      {"language", value}, query when is_binary(value) ->
        from l in query,
          where: ilike(l.language, ^"%#{value}%")

      {"isofficial", "true"}, query ->
        from l in query, where: l.isofficial == true

      {"isofficial", "false"}, query ->
        from l in query, where: l.isofficial == false

      {"percentage_min", value}, query when is_integer(value) ->
        from l in query, where: l.percentage >= ^value

      {"percentage_max", value}, query when is_integer(value) ->
        from l in query, where: l.percentage <= ^value

      _filter, query ->
        query
    end)
  end

  defp filter(query, _options), do: query

  defp sort(query, %{sort_by: sort_by, sort_order: sort_order}) do
    case get_field_type(Language, sort_by) do
      :string ->
        query
        |> order_by([l], {^sort_order, fragment("LOWER(?)", field(l, ^sort_by))})
        |> order_by([l], asc: l.id)

      _ ->
        query
        |> order_by([l], {^sort_order, field(l, ^sort_by)})
        |> order_by([l], asc: l.id)
    end
  end

  defp sort(query, _options), do: query

  defp get_field_type(schema, field_name) do
    schema.__schema__(:type, field_name)
  end

  defp paginate(query, %{page: page, per_page: per_page}) do
    offset = max((page - 1) * per_page, 0)

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  defp paginate(query, _options), do: query

  @doc """
  Gets a single language.

  Raises `Ecto.NoResultsError` if the Language does not exist.

  ## Examples

      iex> get_language!(123)
      %Language{}

      iex> get_language!(456)
      ** (Ecto.NoResultsError)

  """
  # list
  def get_language!(id), do: Repo.get!(Language, id)
  # endlist

  @doc """
  Creates a language.

  ## Examples

      iex> create_language(%{field: value})
      {:ok, %Language{}}

      iex> create_language(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_language(attrs \\ %{}) do
    %Language{}
    |> Language.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:created)
  end

  @doc """
  Updates a language.

  ## Examples

      iex> update_language(language, %{field: new_value})
      {:ok, %Language{}}

      iex> update_language(language, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_language(%Language{} = language, attrs) do
    language
    |> Language.changeset(attrs)
    |> Repo.update(stale_error_field: :lock_version)
    |> broadcast(:updated)
  end

  @doc """
  Deletes a language.

  ## Examples

      iex> delete_language(language)
      {:ok, %Language{}}

      iex> delete_language(language)
      {:error, %Ecto.Changeset{}}

  """
  def delete_language(%Language{} = language) do
    Repo.delete(language)
    |> broadcast(:deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking language changes.

  ## Examples

      iex> change_language(language)
      %Ecto.Changeset{data: %Language{}}

  """
  def change_language(%Language{} = language, attrs \\ %{}, opts \\ []) do
    Language.changeset(language, attrs, opts)
  end
end
