defmodule LivePlayground.CitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LivePlayground.Cities` context.
  """

  @doc """
  Generate a city.
  """
  def city_fixture(attrs \\ %{}) do
    {:ok, city} =
      attrs
      |> Enum.into(%{
        countrycode: "some countrycode",
        district: "some district",
        name: "some name",
        population: 42
      })
      |> LivePlayground.Cities.create_city()

    city
  end
end
