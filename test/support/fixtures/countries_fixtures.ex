defmodule LivePlayground.CountriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LivePlayground.Countries` context.
  """

  @doc """
  Generate a country.
  """
  def country_fixture(attrs \\ %{}) do
    {:ok, country} =
      attrs
      |> Enum.into(%{

      })
      |> LivePlayground.Countries.create_country()

    country
  end

  @doc """
  Generate a country.
  """
  def country_fixture(attrs \\ %{}) do
    {:ok, country} =
      attrs
      |> Enum.into(%{
        capital: 42,
        code: "some code",
        code2: "some code2",
        continent: "some continent",
        gnp: 120.5,
        gnpold: 120.5,
        governmentform: "some governmentform",
        headofstate: "some headofstate",
        indepyear: 42,
        lifeexpectancy: 120.5,
        localname: "some localname",
        name: "some name",
        population: 42,
        region: "some region",
        surfacearea: 120.5
      })
      |> LivePlayground.Countries.create_country()

    country
  end
end
