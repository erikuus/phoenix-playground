defmodule LivePlayground.Repo.Migrations.CopyLanguage do
  use Ecto.Migration

  alias LivePlayground.Repo

  def change do
    copy("priv/repo/language")
  end

  def copy(filepath) do
    sql = """
      COPY language (countrycode, "language", isofficial, percentage) FROM stdin
    """

    stream = Ecto.Adapters.SQL.stream(Repo, sql)

    Repo.transaction(fn ->
      File.stream!(filepath)
      |> Enum.into(stream)
    end)
  end
end
