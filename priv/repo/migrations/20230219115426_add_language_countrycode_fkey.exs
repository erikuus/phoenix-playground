defmodule LivePlayground.Repo.Migrations.AddLanguageCountrycodeFkey do
  use Ecto.Migration

  def change do
    execute "
    ALTER TABLE ONLY language
      ADD CONSTRAINT language_countrycode_fkey FOREIGN KEY (countrycode) REFERENCES country(code)
    "
  end
end
