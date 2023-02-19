defmodule LivePlayground.Repo.Migrations.CopyCountry do
  use Ecto.Migration

  alias LivePlayground.Repo

  def change do
    copy("priv/repo/country")
  end

  def copy(filepath) do
    sql = """
      COPY country (code, name, continent, region, surfacearea, indepyear, population, lifeexpectancy, gnp, gnpold, localname, governmentform, headofstate, capital, code2) FROM stdin
    """

    stream = Ecto.Adapters.SQL.stream(Repo, sql)

    Repo.transaction(fn ->
      File.stream!(filepath)
      |> Enum.into(stream)
    end)
  end
end
