defmodule LivePlayground.Repo.Migrations.CreateLanguage do
  use Ecto.Migration

  def change do
    create table(:language) do
      add :countrycode, :string, size: 3, null: false
      add :language, :text, null: false
      add :isofficial, :boolean, default: false, null: false
      add :percentage, :float, size: 3, null: false
    end
  end
end
