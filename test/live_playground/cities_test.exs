defmodule LivePlayground.CitiesTest do
  use LivePlayground.DataCase

  alias LivePlayground.Cities

  describe "city" do
    alias LivePlayground.Cities.City

    import LivePlayground.CitiesFixtures

    @invalid_attrs %{countrycode: nil, district: nil, name: nil, population: nil}

    test "list_city/0 returns all city" do
      city = city_fixture()
      assert Cities.list_city() == [city]
    end

    test "get_city!/1 returns the city with given id" do
      city = city_fixture()
      assert Cities.get_city!(city.id) == city
    end

    test "create_city/1 with valid data creates a city" do
      valid_attrs = %{countrycode: "some countrycode", district: "some district", name: "some name", population: 42}

      assert {:ok, %City{} = city} = Cities.create_city(valid_attrs)
      assert city.countrycode == "some countrycode"
      assert city.district == "some district"
      assert city.name == "some name"
      assert city.population == 42
    end

    test "create_city/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cities.create_city(@invalid_attrs)
    end

    test "update_city/2 with valid data updates the city" do
      city = city_fixture()
      update_attrs = %{countrycode: "some updated countrycode", district: "some updated district", name: "some updated name", population: 43}

      assert {:ok, %City{} = city} = Cities.update_city(city, update_attrs)
      assert city.countrycode == "some updated countrycode"
      assert city.district == "some updated district"
      assert city.name == "some updated name"
      assert city.population == 43
    end

    test "update_city/2 with invalid data returns error changeset" do
      city = city_fixture()
      assert {:error, %Ecto.Changeset{}} = Cities.update_city(city, @invalid_attrs)
      assert city == Cities.get_city!(city.id)
    end

    test "delete_city/1 deletes the city" do
      city = city_fixture()
      assert {:ok, %City{}} = Cities.delete_city(city)
      assert_raise Ecto.NoResultsError, fn -> Cities.get_city!(city.id) end
    end

    test "change_city/1 returns a city changeset" do
      city = city_fixture()
      assert %Ecto.Changeset{} = Cities.change_city(city)
    end
  end
end
