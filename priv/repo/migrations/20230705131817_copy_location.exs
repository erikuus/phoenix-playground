defmodule LivePlayground.Repo.Migrations.CopyLocation do
  use Ecto.Migration

  alias LivePlayground.Repo

  def change do
    copy("priv/repo/location")
  end

  def copy(filepath) do
    sql = """
      COPY location (name, lat, lng, countrycode)
          FROM stdin
          WITH CSV HEADER DELIMITER ','
    """

    stream = Ecto.Adapters.SQL.stream(Repo, sql)

    Repo.transaction(fn ->
      File.stream!(filepath)
      |> Enum.into(stream)
    end)
  end
end
