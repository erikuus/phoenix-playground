defmodule LivePlayground.PaginatedLanguages do
  @moduledoc """
  The PaginatedLanguages context provides functionality for managing and querying
  language data with pagination support. It includes:

  * CRUD operations for languages
  * Real-time updates via PubSub
  * Pagination helpers for large datasets
  * Optimistic locking for concurrent updates
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.PaginatedLanguages.Language

  @pubsub LivePlayground.PubSub
  @topic "languages"

  @doc """
  Subscribes the current process to language updates.

  LiveView modules should call this function in their mount/3 callback to receive
  real-time notifications when languages are created, updated, or deleted.
  These notifications are sent via broadcast/2 and can be handled in handle_info/2.

  ## Example

      def mount(_params, _session, socket) do
        if connected?(socket), do: PaginatedLanguages.subscribe()
        # ...
      end

      def handle_info({PaginatedLanguages, {event, language}}, socket) do
        # Handle the broadcasted message
      end
  """
  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  @doc """
  Unsubscribes the current process from language updates.

  LiveView modules should call this in their terminate/2 callback to clean up
  subscriptions when the LiveView process is shutting down. This prevents
  memory leaks and ensures proper cleanup of PubSub resources.

  ## Example

      def terminate(_reason, _socket) do
        PaginatedLanguages.unsubscribe()
      end
  """
  def unsubscribe do
    Phoenix.PubSub.unsubscribe(@pubsub, @topic)
  end

  @doc """
  Broadcasts a language change event to all subscribed processes except the sender.
  Handles both successful operations and errors.

  ## Parameters

    * `result` - Either {:ok, language} for success or {:error, changeset} for failures
    * `event` - The type of event (:created, :updated, or :deleted)

  Returns the input tuple unchanged, allowing for function chaining.
  Error tuples are passed through without broadcasting.
  """
  def broadcast({:ok, language}, event) do
    Phoenix.PubSub.broadcast_from(@pubsub, self(), @topic, {__MODULE__, {event, language}})

    {:ok, language}
  end

  def broadcast({:error, changeset}, _event) do
    {:error, changeset}
  end

  @doc """
  Returns the total count of languages in the database.
  Useful for pagination calculations and data overview.
  """
  def count_languages do
    from(Language)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Returns a paginated list of languages ordered by country code and percentage.

  ## Pagination

  The function uses offset-based pagination with the following options:
    * `:page` - The page number to fetch (default: 1)
    * `:per_page` - Number of items per page (default: 10)

  Pagination ensures the offset is never negative by using max/2.

  ## Examples

      # With pagination options
      iex> list_languages(%{page: 2, per_page: 10})
      [%Language{countrycode: "EST", percentage: 95.0}, ...]

      # Without pagination options
      iex> list_languages()
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
  def get_language!(id), do: Repo.get!(Language, id)

  @doc """
  Creates a language and broadcasts the change to all subscribers.

  ## Parameters

    * `attrs` - Map of attributes for creating a language

  ## Examples

      iex> create_language(%{countrycode: "EST", language: "Estonian", percentage: 68.5})
      {:ok, %Language{}}

      iex> create_language(%{countrycode: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_language(attrs \\ %{}) do
    %Language{}
    |> Language.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:created)
  end

  @doc """
  Updates a language with optimistic locking and broadcasts the change.
  Uses lock_version to prevent concurrent updates from overwriting each other.

  ## Parameters

    * `language` - The language struct to update
    * `attrs` - Map of attributes to update

  ## Examples

      iex> update_language(language, %{percentage: 70.2})
      {:ok, %Language{}}

      # When concurrent update detected
      iex> update_language(stale_language, %{percentage: 65.0})
      {:error, %Ecto.Changeset{}}

  """
  def update_language(%Language{} = language, attrs) do
    language
    |> Language.changeset(attrs)
    |> Repo.update(stale_error_field: :lock_version)
    |> broadcast(:updated)
  end

  @doc """
  Deletes a language and broadcasts the deletion to all subscribers.
  Returns an error if the language has associated records preventing deletion.

  ## Parameters

    * `language` - The language struct to delete

  ## Examples

      iex> delete_language(language)
      {:ok, %Language{}}

      # When deletion is prevented by constraints
      iex> delete_language(language_with_dependencies)
      {:error, %Ecto.Changeset{}}

  """
  def delete_language(%Language{} = language) do
    Repo.delete(language)
    |> broadcast(:deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking language changes.
  Useful for building forms and validating changes before persisting them.

  ## Parameters

    * `language` - The language struct to create a changeset for
    * `attrs` - Optional map of changes to apply
    * `opts` - Optional list of options for the changeset

  ## Examples

      # For a new language
      iex> change_language(%Language{})
      %Ecto.Changeset{data: %Language{}}

      # With changes
      iex> change_language(language, %{percentage: 75.0})
      %Ecto.Changeset{changes: %{percentage: 75.0}, data: %Language{}}

  """
  def change_language(%Language{} = language, attrs \\ %{}, opts \\ []) do
    Language.changeset(language, attrs, opts)
  end
end
