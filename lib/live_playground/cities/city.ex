defmodule LivePlayground.Cities.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "city" do
    field :countrycode, :string
    field :district, :string
    field :name, :string
    field :population, :integer
    field :lock_version, :integer, default: 0
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :countrycode, :district, :population])
    |> validate_required([:name, :district, :population])
    |> validate_length(:name, min: 3, max: 50)
    |> validate_length(:district, min: 3, max: 100)
    |> validate_length(:countrycode, is: 3)
    |> validate_number(:population, greater_than: 1000)
    |> optimistic_lock(:lock_version)
  end
end
