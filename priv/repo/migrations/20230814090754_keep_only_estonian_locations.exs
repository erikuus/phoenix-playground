defmodule LivePlayground.Repo.Migrations.KeepOnlyEstonianLocations do
  use Ecto.Migration

  def change do
    execute "
    DELETE FROM location WHERE countrycode!='EST'
    "
  end
end
