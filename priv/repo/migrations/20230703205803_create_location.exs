defmodule LivePlayground.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:location) do
      add :name, :text, null: false
      add :countrycode, :string, size: 3, null: false
      add :lat, :float, null: false
      add :lng, :float, null: false
    end
  end
end
