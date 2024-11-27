defmodule LivePlayground.Languages2.Language do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias LivePlayground.Repo

  schema "language" do
    field :countrycode, :string
    field :isofficial, :boolean, default: false
    field :language, :string
    field :percentage, :float
    field :lock_version, :integer, default: 0
  end

  def changeset(language, attrs, opts \\ []) do
    language
    |> cast(attrs, [:countrycode, :language, :isofficial, :percentage, :lock_version])
    |> update_change(:countrycode, &String.upcase/1)
    |> validate_required([:countrycode, :language, :isofficial, :percentage])
    |> validate_length(:language, min: 2, max: 30)
    |> validate_number(:percentage, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> maybe_validate_countrycode_exists(opts)
    |> optimistic_lock(:lock_version)
  end

  defp maybe_validate_countrycode_exists(changeset, opts) do
    if Keyword.get(opts, :validate_countrycode_exists, true) do
      validate_countrycode_exists(changeset)
    else
      changeset
    end
  end

  defp validate_countrycode_exists(changeset) do
    countrycode = get_field(changeset, :countrycode)

    if is_nil(countrycode) or countrycode == "" do
      changeset
    else
      if Repo.exists?(from c in "country", where: c.code == ^countrycode) do
        changeset
      else
        add_error(changeset, :countrycode, "does not exist")
      end
    end
  end
end
