defmodule LivePlayground.Cities do
  @moduledoc """
  The Cities context.
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.Cities.City

  @doc """
  Returns the list of city.

  ## Examples

      iex> list_city()
      [%City{}, ...]

  """
  def list_city do
    Repo.all(City)
  end

  @doc """
  Returns the list of cities of USA matching the given filter.

  ## Examples

      iex> list_usa_city(%{district: ""})
      [%City{}, ...]

  """
  def list_usa_city(filter) when is_map(filter) do
    from(City)
    |> where(countrycode: "USA")
    |> filter_by_name(filter)
    |> filter_by_district(filter)
    |> filter_by_sizes(filter)
    |> Repo.all()
  end

  defp filter_by_name(query, %{name: ""}), do: query

  defp filter_by_name(query, %{name: name}) do
    ilike = "%#{name}%"
    where(query, [c], ilike(c.name, ^ilike))
  end

  defp filter_by_district(query, %{district: ""}), do: query

  defp filter_by_district(query, %{district: district}) do
    where(query, district: ^district)
  end

  defp filter_by_sizes(query, %{sizes: [""]}), do: query

  defp filter_by_sizes(query, %{sizes: sizes}) do
    conditions =
      sizes
      |> Enum.reject(&(&1 == ""))
      |> Enum.reduce(dynamic(false), fn size, dynamic ->
        dynamic([c], ^condition_by_size(size, dynamic))
      end)

    where(query, ^conditions)
  end

  defp condition_by_size(size, dynamic) do
    %{
      "Small" => dynamic([c], c.population <= 500_000 or ^dynamic),
      "Medium" => dynamic([c], (c.population > 500_000 and c.population < 1_000_000) or ^dynamic),
      "Large" => dynamic([c], c.population >= 1_000_000 or ^dynamic)
    }[size]
  end

  def list_distinct_usa_district() do
    from(City)
    |> select([:district])
    |> where(countrycode: "USA")
    |> order_by(asc: :district)
    |> distinct(true)
    |> Repo.all()
    |> Enum.map(fn x -> x.district end)
  end

  @doc """
  Gets a single city.

  Raises `Ecto.NoResultsError` if the City does not exist.

  ## Examples

      iex> get_city!(123)
      %City{}

      iex> get_city!(456)
      ** (Ecto.NoResultsError)

  """
  def get_city!(id), do: Repo.get!(City, id)

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{field: value})
      {:ok, %City{}}

      iex> create_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a city.

  ## Examples

      iex> update_city(city, %{field: new_value})
      {:ok, %City{}}

      iex> update_city(city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a city.

  ## Examples

      iex> delete_city(city)
      {:ok, %City{}}

      iex> delete_city(city)
      {:error, %Ecto.Changeset{}}

  """
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking city changes.

  ## Examples

      iex> change_city(city)
      %Ecto.Changeset{data: %City{}}

  """
  def change_city(%City{} = city, attrs \\ %{}) do
    City.changeset(city, attrs)
  end
end
