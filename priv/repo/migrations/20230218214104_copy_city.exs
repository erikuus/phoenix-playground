defmodule LivePlayground.Repo.Migrations.CopyCity do
  use Ecto.Migration

  alias LivePlayground.Repo

  def change do
    copy("priv/repo/city")
  end

  def copy(filepath) do
    sql = """
      COPY city (id, name, countrycode, district, population) FROM stdin
    """

    stream = Ecto.Adapters.SQL.stream(Repo, sql)

    Repo.transaction(fn ->
      File.stream!(filepath)
      |> Enum.into(stream)
    end)
  end
end
