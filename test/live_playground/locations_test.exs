defmodule LivePlayground.LocationsTest do
  use LivePlayground.DataCase

  alias LivePlayground.Locations

  describe "location" do
    alias LivePlayground.Locations.Location

    import LivePlayground.LocationsFixtures

    @invalid_attrs %{lat: nil, lng: nil, name: nil}

    test "list_location/0 returns all location" do
      location = location_fixture()
      assert Locations.list_location() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Locations.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      valid_attrs = %{lat: 120.5, lng: 120.5, name: "some name"}

      assert {:ok, %Location{} = location} = Locations.create_location(valid_attrs)
      assert location.lat == 120.5
      assert location.lng == 120.5
      assert location.name == "some name"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Locations.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      update_attrs = %{lat: 456.7, lng: 456.7, name: "some updated name"}

      assert {:ok, %Location{} = location} = Locations.update_location(location, update_attrs)
      assert location.lat == 456.7
      assert location.lng == 456.7
      assert location.name == "some updated name"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Locations.update_location(location, @invalid_attrs)
      assert location == Locations.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Locations.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Locations.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Locations.change_location(location)
    end
  end
end
