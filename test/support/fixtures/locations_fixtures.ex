defmodule LivePlayground.LocationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LivePlayground.Locations` context.
  """

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        lat: 120.5,
        lng: 120.5,
        name: "some name"
      })
      |> LivePlayground.Locations.create_location()

    location
  end
end
