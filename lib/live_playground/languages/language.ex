defmodule LivePlayground.Languages.Language do
  use Ecto.Schema
  import Ecto.Changeset

  schema "language" do
    field :countrycode, :string
    field :isofficial, :boolean, default: false
    field :language, :string
    field :percentage, :float
  end

  @doc false
  def changeset(language, attrs) do
    language
    |> cast(attrs, [:countrycode, :language, :isofficial, :percentage])
    |> validate_required([:countrycode, :language, :isofficial, :percentage])
  end
end
