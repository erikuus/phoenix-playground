defmodule LivePlayground.Languages2 do
  @moduledoc """
  The Languages context.
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.Languages2.Language

  @pubsub LivePlayground.PubSub
  @topic inspect(__MODULE__)

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
  Returns the list of language.

  ## Examples

      iex> list_language()
      [%Language{}, ...]
  """
  def list_languages(options \\ %{}) do
    from(Language)
    |> order_by([l], [{:asc, l.countrycode}, {:desc, l.percentage}])
    |> paginate(options)
    |> Repo.all()
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
