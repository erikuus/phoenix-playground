defmodule LivePlayground.Repo.Migrations.AddCountryCodeUnique do
  use Ecto.Migration

  def change do
    execute "
    ALTER TABLE country
      ADD CONSTRAINT country_code_unique UNIQUE (code)
    "
  end
end
