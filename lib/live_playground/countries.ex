defmodule LivePlayground.Countries do
  @moduledoc """
  The Countries context.
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.Countries.Country

  # broadcast
  @pubsub LivePlayground.PubSub
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  def broadcast({:ok, country}, event) do
    Phoenix.PubSub.broadcast(@pubsub, @topic, {event, country})

    {:ok, country}
  end

  def broadcast({:error, changeset}, _event) do
    {:error, changeset}
  end

  # endbroadcast

  @doc """
  Returns the list of country.

  ## Examples

      iex> list_country()
      [%Country{}, ...]

  """
  def list_country do
    Repo.all(Country)
  end

  # search
  def list_country(query) when query != "" do
    q = "%#{query}%"

    from(Country)
    |> where([c], ilike(c.name, ^q))
    |> Repo.all()
  end

  # endsearch
  def list_country(_query) do
    []
  end

  # clickbuttons # handleparams
  def list_region_country(region, population \\ 100_000) do
    from(Country)
    |> where(region: ^region)
    |> where([c], c.population >= ^population)
    |> Repo.all()
  end

  # endclickbuttons # endhandleparams

  @doc """
  Gets a single country.

  Raises `Ecto.NoResultsError` if the Country does not exist.

  ## Examples

      iex> get_country!(123)
      %Country{}

      iex> get_country!(456)
      ** (Ecto.NoResultsError)

  """
  # broadcast
  def get_country!(id), do: Repo.get!(Country, id)

  # endbroadcast

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{field: value})
      {:ok, %Country{}}

      iex> create_country(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{field: new_value})
      {:ok, %Country{}}

      iex> update_country(country, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  # broadcast
  def update_country_broadcast(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
    |> broadcast(:update_country)
  end

  # endbroadcast

  @doc """
  Deletes a country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country changes.

  ## Examples

      iex> change_country(country)
      %Ecto.Changeset{data: %Country{}}

  """
  # broadcast
  def change_country(%Country{} = country, attrs \\ %{}) do
    Country.changeset(country, attrs)
  end

  # endbroadcast
end
