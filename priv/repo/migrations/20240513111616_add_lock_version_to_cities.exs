defmodule LivePlayground.Repo.Migrations.AddLockVersionToCities do
  use Ecto.Migration

  def change do
    alter table(:city) do
      add :lock_version, :integer, default: 0, null: false
    end
  end
end
