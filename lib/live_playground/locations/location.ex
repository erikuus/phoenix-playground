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
    field :photos, {:array, :string}, default: []
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :lat, :lng, :photos])
    |> validate_required([:name, :lat, :lng, :photos])
    |> validate_length(:countrycode, is: 3)
  end
end
