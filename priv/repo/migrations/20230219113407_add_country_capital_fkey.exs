defmodule LivePlayground.Repo.Migrations.AddCountryCapitalFkey do
  use Ecto.Migration

  def change do
    execute "
    ALTER TABLE ONLY country
      ADD CONSTRAINT country_capital_fkey FOREIGN KEY (capital) REFERENCES city(id)
    "
  end
end
