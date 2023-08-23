defmodule LivePlayground.Repo.Migrations.AddColumnLocationsPhotosS3 do
  use Ecto.Migration

  def change do
    alter table(:location) do
      add :photos_s3, {:array, :string}, null: false, default: []
    end
  end
end
