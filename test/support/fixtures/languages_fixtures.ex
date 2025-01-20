defmodule LivePlayground.LanguagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LivePlayground.Languages` context.
  """

  @doc """
  Generate a language.
  """
  def language_fixture(attrs \\ %{}) do
    {:ok, language} =
      attrs
      |> Enum.into(%{
        name: "some name",
        countrycode: "some countrycode"
      })
      |> LivePlayground.Languages.create_language()

    language
  end
end
