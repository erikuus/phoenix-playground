defmodule LivePlayground.SortedLanguages do
  @moduledoc """
  The SortedLanguages context.
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.SortedLanguages.Language

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

  def count_languages do
    from(Language)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Fetches a paginated and sorted list of languages based on the provided options.

  ## Sorting
  - The `sort_by` option specifies the field to sort by (e.g., `:name`, `:id`).
  - The `sort_order` option specifies the sort direction (`:asc` or `:desc`).
  - For string fields, sorting is **case-insensitive** (e.g., "ruby" and "Ruby" are treated as equal).
  - To ensure consistent ordering across pages, a secondary sort by `id` is always applied.
    This prevents rows with the same value in the primary sort field from appearing in multiple pages.

  ## Pagination
  - The `page` option specifies the page number (1-based).
  - The `per_page` option specifies the number of items per page.
  - Pagination is implemented using `limit` and `offset`.

  ## Examples
      # Sort by name (case-insensitive) and paginate
      list_languages(%{sort_by: :name, sort_order: :asc, page: 1, per_page: 10})

      # Sort by ID in descending order and paginate
      list_languages(%{sort_by: :id, sort_order: :desc, page: 2, per_page: 5})

  ## Notes
  - If `sort_by` or `sort_order` is not provided, no sorting is applied.
  - If `page` or `per_page` is not provided, no pagination is applied.
  - The function assumes that the `Language` schema has an `id` field for secondary sorting.
  """
  def list_languages(options \\ %{}) do
    from(Language)
    |> sort(options)
    |> paginate(options)
    |> Repo.all()
  end

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
