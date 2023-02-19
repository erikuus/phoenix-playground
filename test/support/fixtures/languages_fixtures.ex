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
        countrycode: "some countrycode",
        isofficial: true,
        language: "some language",
        percentage: 120.5
      })
      |> LivePlayground.Languages.create_language()

    language
  end
end
