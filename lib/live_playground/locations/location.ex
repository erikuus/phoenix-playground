defmodule LivePlayground.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  # jshookmapdataset
  @derive {Jason.Encoder, only: [:id, :name, :lat, :lng]}
  # endjshookmapdataset

  schema "location" do
    field :name, :string
    field :countrycode, :string
    field :lat, :float
    field :lng, :float
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :lat, :lng])
    |> validate_required([:name, :lat, :lng])
    |> validate_length(:countrycode, is: 3)
  end
end
