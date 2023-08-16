defmodule LivePlayground.Repo.Migrations.AddColumnLocationsPhotos do
  use Ecto.Migration

  def change do
    alter table(:location) do
      add :photos, {:array, :string}, null: false, default: []
    end
  end
end
