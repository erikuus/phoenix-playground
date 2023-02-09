defmodule LivePlayground.Repo.Migrations.UpdateCountryTable do
  use Ecto.Migration

  alias LivePlayground.Repo

  def change do
    copy("priv/repo/country.csv")
  end

  def copy(filepath) do
    sql = """
      COPY country(name,code_number,code,code2,latitude,longitude)
      FROM STDIN
      WITH DELIMITER ',' CSV
    """

    stream = Ecto.Adapters.SQL.stream(Repo, sql)

    Repo.transaction(fn ->
      File.stream!(filepath)
      |> Enum.into(stream)
    end)
  end
end
