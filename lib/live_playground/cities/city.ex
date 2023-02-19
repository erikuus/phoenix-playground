defmodule LivePlayground.Cities.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "city" do
    field :countrycode, :string
    field :district, :string
    field :name, :string
    field :population, :integer
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :countrycode, :district, :population])
    |> validate_required([:name, :countrycode, :district, :population])
  end
end
