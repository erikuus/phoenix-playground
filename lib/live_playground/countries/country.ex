defmodule LivePlayground.Countries.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "country" do
    field :capital, :integer
    field :code, :string
    field :code2, :string
    field :continent, :string
    field :gnp, :float
    field :gnpold, :float
    field :governmentform, :string
    field :headofstate, :string
    field :indepyear, :integer
    field :lifeexpectancy, :float
    field :localname, :string
    field :name, :string
    field :population, :integer
    field :region, :string
    field :surfacearea, :float
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [
      :code,
      :name,
      :continent,
      :region,
      :surfacearea,
      :indepyear,
      :population,
      :lifeexpectancy,
      :gnp,
      :gnpold,
      :localname,
      :governmentform,
      :headofstate,
      :capital,
      :code2
    ])
    |> validate_required([
      :code,
      :name,
      :continent,
      :region,
      :surfacearea,
      :indepyear,
      :population,
      :lifeexpectancy,
      :gnp,
      :gnpold,
      :localname,
      :governmentform,
      :headofstate,
      :capital,
      :code2
    ])
  end
end
