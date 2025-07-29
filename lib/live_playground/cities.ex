defmodule LivePlayground.Cities do
  @moduledoc """
  The Cities context.
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.Cities.City

  # broadcaststream_ # broadcaststreamreset # tabularinsert
  @pubsub LivePlayground.PubSub
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  def unsubscribe do
    Phoenix.PubSub.unsubscribe(@pubsub, @topic)
  end

  @doc """
  Broadcasts a database operation result to subscribed processes.

  There are two Phoenix PubSub broadcast options:
  - `broadcast/3` - Sends message to ALL subscribed processes (including sender)
  - `broadcast_from/4` - Sends message to ALL subscribed processes EXCEPT sender

  This function uses `broadcast_from/4` with `self()` because:
  - The calling process already has the updated data from the database operation
  - Sending the broadcast back to the originating process would cause redundant updates
  - Other processes need the broadcast to update their state in real-time

  The function handles two possible outcomes:
  - `{:ok, city}` - Successful operation, broadcasts the event to other processes
  - `{:error, changeset}` - Failed operation, passes through the error unchanged
  """
  def broadcast({:ok, city}, event) do
    Phoenix.PubSub.broadcast_from(@pubsub, self(), @topic, {__MODULE__, {event, city}})
    {:ok, city}
  end

  def broadcast({:error, changeset}, _event) do
    {:error, changeset}
  end

  # endbroadcaststream_ # endbroadcaststreamreset # endtabularinsert

  def list_city do
    Repo.all(City)
  end

  # paginate
  def count_country_city(countrycode) do
    from(City)
    |> where(countrycode: ^countrycode)
    |> Repo.aggregate(:count, :id)
  end

  # endpaginate

  @doc """
  Gets all cities for a country code ordered by name.

  This is a simplified version of `list_country_city/2` designed specifically
  for stream examples. Unlike the full version, this function does not support
  filtering, sorting options, or pagination.

  ## Parameters
    - `countrycode`: The ISO country code (e.g., 'EST' for Estonia).

  ## Returns
    - A list of %City{} structs for the specified country, ordered by name ascending.

  ## Examples

      iex> list_country_city_stream("EST")
      [%City{name: "Tallinn", ...}, %City{name: "Tartu", ...}]

  """
  # form # streaminsert # streamreset # streamupdate # broadcaststream_ # broadcaststreamreset
  def list_country_city(countrycode) do
    from(City)
    |> where(countrycode: ^countrycode)
    |> order_by(asc: :name)
    |> Repo.all()
  end

  # endform # endstreaminsert # endstreamreset # endstreamupdate # endbroadcaststream_  # endbroadcaststreamreset

  # filter

  @doc """
  Fetches a list of cities filtered by various criteria from the database for a specified country code.

  ## Parameters:
    - `countrycode`: The ISO country code (e.g., 'US' for the United States).
    - `options`: A map of options to further filter and sort the results.

  ## Options:
    - `name`: Filter cities by name using a case-insensitive like match. (e.g., `%{name: "York"}`).
    - `district`: Filter cities by their district exactly matching the given string.
    - `sm`: Include cities with a population less than or equal to 500,000 (`"true"` or `"false"`).
    - `md`: Include cities with a population greater than 500,000 and less than 1,000,000 (`"true"` or `"false"`).
    - `lg`: Include cities with a population of at least 1,000,000 (`"true"` or `"false"`).
    - `sort_by`: Column to sort by (e.g., :name, :population).
    - `sort_order`: Order of sorting, either `:asc` for ascending or `:desc` for descending.

  ## Example:
    Given `countrycode` = 'US' and
    `options` = %{name: "New", district: "York", sm: "true", md: "true", lg: "true", sort_by: :population, sort_order: :desc},
    the function constructs and executes the following SQL query:
    ```sql
    SELECT * FROM cities
    WHERE countrycode = 'US'
    AND lower(name) LIKE '%new%'
    AND district = 'York'
    AND (
        population <= 500000 OR
        (population > 500000 AND population < 1000000) OR
        population >= 1000000
    )
    ORDER BY population DESC

  ## Returns:
    - A list of %City{} structs matching the criteria, sorted and paginated according to the options.
  """
  # paginate # sort # tabularinsert
  def list_country_city(countrycode, options) do
    from(City)
    |> where(countrycode: ^countrycode)
    |> filter_by_name(options)
    |> filter_by_district(options)
    |> filter_by_size(options)
    |> sort(options)
    |> paginate(options)
    |> Repo.all()
  end

  # endpaginate # endfilter # endsort # endtabularinsert

  # filter
  defp filter_by_name(query, %{name: name}) when name != "" do
    ilike = "%#{name}%"
    where(query, [c], ilike(c.name, ^ilike))
  end

  defp filter_by_name(query, _options), do: query

  defp filter_by_district(query, %{district: district}) when district != "" do
    where(query, district: ^district)
  end

  defp filter_by_district(query, _options), do: query

  defp filter_by_size(query, %{sm: "false", md: "false", lg: "false"}), do: query

  defp filter_by_size(query, %{sm: _sm, md: _md, lg: _lg} = options) do
    size_conditions =
      dynamic(false)
      |> add_sm_condition(options)
      |> add_md_condition(options)
      |> add_lg_condition(options)

    where(query, ^size_conditions)
  end

  defp filter_by_size(query, _options), do: query

  defp add_sm_condition(dynamic, %{sm: "true"}) do
    dynamic([c], c.population <= 500_000 or ^dynamic)
  end

  defp add_sm_condition(dynamic, _), do: dynamic

  defp add_md_condition(dynamic, %{md: "true"}) do
    dynamic([c], (c.population > 500_000 and c.population < 1_000_000) or ^dynamic)
  end

  defp add_md_condition(dynamic, _), do: dynamic

  defp add_lg_condition(dynamic, %{lg: "true"}) do
    dynamic([c], c.population >= 1_000_000 or ^dynamic)
  end

  defp add_lg_condition(dynamic, _), do: dynamic

  def list_distinct_country_districts(countrycode) do
    from(c in City,
      where: c.countrycode == ^countrycode,
      select: c.district,
      distinct: true,
      order_by: c.district
    )
    |> Repo.all()
  end

  # endfilter

  # sort
  defp sort(query, %{sort_by: sort_by, sort_order: sort_order}) do
    order_by(query, {^sort_order, ^sort_by})
  end

  defp sort(query, _options), do: query

  # endsort

  # paginate
  defp paginate(query, %{page: page, per_page: per_page}) do
    offset = max((page - 1) * per_page, 0)

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  defp paginate(query, _options), do: query

  # endpaginate

  @doc """
  Gets a single city.

  Raises `Ecto.NoResultsError` if the City does not exist.

  ## Examples

      iex> get_city!(123)
      %City{}

      iex> get_city!(456)
      ** (Ecto.NoResultsError)

  """
  # streamupdate # streamreset # broadcaststream_ # broadcaststreamreset # tabularinsert
  def get_city!(id), do: Repo.get!(City, id)

  # endstreamupdate # endstreamreset # endbroadcaststream_ # endbroadcaststreamreset # endtabularinsert

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{field: value})
      {:ok, %City{}}

      iex> create_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # form # streaminsert # streamreset
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  # endform # endstreaminsert # endstreamreset

  # broadcaststream_ # broadcaststreamreset # tabularinsert
  def create_city_broadcast(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:create_city)
  end

  # endbroadcaststream_ # endbroadcaststreamreset # endtabularinsert

  @doc """
  Updates a city.

  ## Examples

      iex> update_city(city, %{field: new_value})
      {:ok, %City{}}

      iex> update_city(city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # streamupdate # streamreset
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  # endstreamupdate # endstreamreset

  # broadcaststream_ # broadcaststreamreset
  def update_city_broadcast(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update(stale_error_field: :lock_version)
    |> broadcast(:update_city)
  end

  # endbroadcaststream_ # endbroadcaststreamreset

  @doc """
  Deletes a city.

  ## Examples

      iex> delete_city(city)
      {:ok, %City{}}

      iex> delete_city(city)
      {:error, %Ecto.Changeset{}}

  """
  # streaminsert # streamreset
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  # endstreaminsert # endstreamreset

  # broadcaststream_ # broadcaststreamreset # tabularinsert
  def delete_city_broadcast(%City{} = city) do
    Repo.delete(city)
    |> broadcast(:delete_city)
  end

  # endbroadcaststream_ # endbroadcaststreamreset # endtabularinsert

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking city changes.

  ## Examples

      iex> change_city(city)
      %Ecto.Changeset{data: %City{}}

  """
  # form # streaminsert # streamreset # streamupdate # broadcaststream_ # broadcaststreamreset # tabularinsert # upload
  def change_city(%City{} = city, attrs \\ %{}) do
    City.changeset(city, attrs)
  end

  # endform # endstreaminsert # endstreamreset # endstreamupdate # endbroadcaststream_ # endbroadcaststreamreset # endtabularinsert # endupload
end
