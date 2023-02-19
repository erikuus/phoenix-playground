defmodule LivePlayground.Repo.Migrations.CreateCity do
  use Ecto.Migration

  def change do
    create table(:city) do
      add :name, :text, null: false
      add :countrycode, :string, size: 3, null: false
      add :district, :text, null: false
      add :population, :integer, null: false
    end
  end
end
