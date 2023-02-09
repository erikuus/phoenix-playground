defmodule LivePlayground.Repo.Migrations.CreateCountryTable do
  use Ecto.Migration

  def change do
    create table(:country) do
      add :name, :string, size: 128
      add :code_number, :string, size: 3
      add :code, :string, size: 3
      add :code2, :string, size: 3
      add :latitude, :float
      add :longitude, :float
    end
  end
end
