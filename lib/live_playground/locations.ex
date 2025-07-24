defmodule LivePlayground.Locations do
  @moduledoc """
  The Locations context.
  """

  import Ecto.Query, warn: false
  alias LivePlayground.Repo

  alias LivePlayground.Locations.Location

  # uploadserver # uploadcloud
  @pubsub LivePlayground.PubSub
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  def broadcast({:ok, location}, event) do
    Phoenix.PubSub.broadcast(@pubsub, @topic, {event, location})

    {:ok, location}
  end

  def broadcast({:error, changeset}, _event) do
    {:error, changeset}
  end

  # enduploadserver # enduploadcloud

  @doc """
  Returns the list of location.

  ## Examples

      iex> list_location()
      [%Location{}, ...]

  """
  def list_location do
    Repo.all(Location)
  end

  # jshooks
  def list_est_location() do
    from(Location)
    |> where(countrycode: "EST")
    |> order_by(:name)
    |> Repo.all()
  end

  # endjshooks

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  # uploadserver # uploadcloud
  def get_location!(id), do: Repo.get!(Location, id)
  # enduploadserver # enduploadcloud

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # uploadserver # uploadcloud
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
    |> broadcast(:update_location)
  end

  # enduploadserver # enduploadcloud

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  # uploadserver # uploadcloud
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  # enduploadserver # enduploadcloud
end
