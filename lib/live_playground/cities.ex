defmodule LivePlayground.Cities do
  @moduledoc """
  The Cities context.
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.Cities.City

  # broadcaststream # tabularinsert
  @pubsub LivePlayground.PubSub
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  def broadcast({:ok, city}, event) do
    Phoenix.PubSub.broadcast(@pubsub, @topic, {event, city})

    {:ok, city}
  end

  def broadcast({:error, changeset}, _event) do
    {:error, changeset}
  end

  # endbroadcaststream # endtabularinsert

  # paginate
  def count_city do
    Repo.aggregate(City, :count, :id)
  end

  def list_city(options) when is_map(options) do
    from(City)
    |> paginate(options)
    |> order_by({:desc, :population})
    |> Repo.all()
  end

  defp paginate(query, %{page: page, per_page: per_page}) do
    offset = max((page - 1) * per_page, 0)

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  defp paginate(query, _options), do: query

  def list_city do
    Repo.all(City)
  end

  # endpaginate

  # form # streaminsert # streamupdate # broadcaststream # tabularinsert
  def list_est_city() do
    from(City)
    |> where(countrycode: "EST")
    |> order_by(:name)
    |> Repo.all()
  end

  # endform # endstreaminsert  # endstreamupdate # endbroadcaststream # endtabularinsert

  # sort
  def list_est_city(options) when is_map(options) do
    from(City)
    |> where(countrycode: "EST")
    |> sort(options)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_order: sort_order}) do
    order_by(query, {^sort_order, ^sort_by})
  end

  defp sort(query, _options), do: query

  # endsort

  # filter
  def list_usa_city(filter) when is_map(filter) do
    from(City)
    |> where(countrycode: "USA")
    |> filter_by_name(filter)
    |> filter_by_district(filter)
    |> filter_by_size(filter)
    |> Repo.all()
  end

  defp filter_by_name(query, %{name: ""}), do: query

  defp filter_by_name(query, %{name: name}) do
    ilike = "%#{name}%"
    where(query, [c], ilike(c.name, ^ilike))
  end

  defp filter_by_district(query, %{dist: ""}), do: query

  defp filter_by_district(query, %{dist: district}) do
    where(query, district: ^district)
  end

  defp filter_by_size(query, %{sm: "false", md: "false", lg: "false"}), do: query

  defp filter_by_size(query, filter) do
    size_conditions =
      dynamic(false)
      |> condition_by_sm(filter)
      |> condition_by_md(filter)
      |> condition_by_lg(filter)

    where(query, ^size_conditions)
  end

  defp condition_by_sm(dynamic, %{sm: "false"}), do: dynamic

  defp condition_by_sm(dynamic, %{sm: "true"}) do
    dynamic([c], c.population <= 500_000 or ^dynamic)
  end

  defp condition_by_md(dynamic, %{md: "false"}), do: dynamic

  defp condition_by_md(dynamic, %{md: "true"}) do
    dynamic([c], (c.population > 500_000 and c.population < 1_000_000) or ^dynamic)
  end

  defp condition_by_lg(dynamic, %{lg: "false"}), do: dynamic

  defp condition_by_lg(dynamic, %{lg: "true"}) do
    dynamic([c], c.population >= 1_000_000 or ^dynamic)
  end

  def list_distinct_usa_district() do
    from(City)
    |> select([:district])
    |> where(countrycode: "USA")
    |> order_by(asc: :district)
    |> distinct(true)
    |> Repo.all()
  end

  # endfilter

  @doc """
  Gets a single city.

  Raises `Ecto.NoResultsError` if the City does not exist.

  ## Examples

      iex> get_city!(123)
      %City{}

      iex> get_city!(456)
      ** (Ecto.NoResultsError)

  """
  # streamupdate # broadcaststream # tabularinsert
  def get_city!(id), do: Repo.get!(City, id)
  # streamupdate # endbroadcaststream # endtabularinsert

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{field: value})
      {:ok, %City{}}

      iex> create_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # form # streaminsert
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  # endform # endstreaminsert

  # broadcaststream # tabularinsert
  def create_city_broadcast(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:create_city)
  end

  # endbroadcaststream # endtabularinsert

  @doc """
  Updates a city.

  ## Examples

      iex> update_city(city, %{field: new_value})
      {:ok, %City{}}

      iex> update_city(city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # streamupdate
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  # endstreamupdate

  # broadcaststream
  def update_city_broadcast(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
    |> broadcast(:update_city)
  end

  # endbroadcaststream

  @doc """
  Deletes a city.

  ## Examples

      iex> delete_city(city)
      {:ok, %City{}}

      iex> delete_city(city)
      {:error, %Ecto.Changeset{}}

  """
  # streaminsert
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  # endstreaminsert

  # broadcaststream # tabularinsert
  def delete_city_broadcast(%City{} = city) do
    Repo.delete(city)
    |> broadcast(:delete_city)
  end

  # endbroadcaststream # endtabularinsert

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking city changes.

  ## Examples

      iex> change_city(city)
      %Ecto.Changeset{data: %City{}}

  """
  # form # streaminsert # streamupdate # broadcaststream # tabularinsert
  def change_city(%City{} = city, attrs \\ %{}) do
    City.changeset(city, attrs)
  end

  # endform # endstreaminsert # endstreamupdate # endbroadcaststream # endtabularinsert
end
