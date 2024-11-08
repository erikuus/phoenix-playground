defmodule LivePlayground.Repo.Migrations.AddLockVersionToLanguages do
  use Ecto.Migration

  def change do
    alter table(:language) do
      add :lock_version, :integer, default: 0, null: false
    end
  end
end
