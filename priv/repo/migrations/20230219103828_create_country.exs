defmodule LivePlayground.Repo.Migrations.CreateCountry do
  use Ecto.Migration

  def change do
    create table(:country) do
      add :code, :string, size: 3, null: false
      add :name, :text, null: false
      add :continent, :text, null: false
      add :region, :text, null: false
      add :surfacearea, :float, null: false
      add :indepyear, :integer
      add :population, :integer, null: false
      add :lifeexpectancy, :float
      add :gnp, :float
      add :gnpold, :float
      add :localname, :text, null: false
      add :governmentform, :text, null: false
      add :headofstate, :text
      add :capital, :integer
      add :code2, :string, size: 2, null: false
    end
  end
end
