defmodule LivePlayground.Countries.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "country" do
    field :name, :string
    field :code_number, :string
    field :code, :string
    field :code2, :string
    field :latitude, :float
    field :longitude, :float
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [])
    |> validate_required([])
  end
end
