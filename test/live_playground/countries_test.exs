defmodule LivePlayground.CountriesTest do
  use LivePlayground.DataCase

  alias LivePlayground.Countries

  describe "country" do
    alias LivePlayground.Countries.Country

    import LivePlayground.CountriesFixtures

    @invalid_attrs %{capital: nil, code: nil, code2: nil, continent: nil, gnp: nil, gnpold: nil, governmentform: nil, headofstate: nil, indepyear: nil, lifeexpectancy: nil, localname: nil, name: nil, population: nil, region: nil, surfacearea: nil}

    test "list_country/0 returns all country" do
      country = country_fixture()
      assert Countries.list_country() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Countries.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      valid_attrs = %{capital: 42, code: "some code", code2: "some code2", continent: "some continent", gnp: 120.5, gnpold: 120.5, governmentform: "some governmentform", headofstate: "some headofstate", indepyear: 42, lifeexpectancy: 120.5, localname: "some localname", name: "some name", population: 42, region: "some region", surfacearea: 120.5}

      assert {:ok, %Country{} = country} = Countries.create_country(valid_attrs)
      assert country.capital == 42
      assert country.code == "some code"
      assert country.code2 == "some code2"
      assert country.continent == "some continent"
      assert country.gnp == 120.5
      assert country.gnpold == 120.5
      assert country.governmentform == "some governmentform"
      assert country.headofstate == "some headofstate"
      assert country.indepyear == 42
      assert country.lifeexpectancy == 120.5
      assert country.localname == "some localname"
      assert country.name == "some name"
      assert country.population == 42
      assert country.region == "some region"
      assert country.surfacearea == 120.5
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Countries.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      update_attrs = %{capital: 43, code: "some updated code", code2: "some updated code2", continent: "some updated continent", gnp: 456.7, gnpold: 456.7, governmentform: "some updated governmentform", headofstate: "some updated headofstate", indepyear: 43, lifeexpectancy: 456.7, localname: "some updated localname", name: "some updated name", population: 43, region: "some updated region", surfacearea: 456.7}

      assert {:ok, %Country{} = country} = Countries.update_country(country, update_attrs)
      assert country.capital == 43
      assert country.code == "some updated code"
      assert country.code2 == "some updated code2"
      assert country.continent == "some updated continent"
      assert country.gnp == 456.7
      assert country.gnpold == 456.7
      assert country.governmentform == "some updated governmentform"
      assert country.headofstate == "some updated headofstate"
      assert country.indepyear == 43
      assert country.lifeexpectancy == 456.7
      assert country.localname == "some updated localname"
      assert country.name == "some updated name"
      assert country.population == 43
      assert country.region == "some updated region"
      assert country.surfacearea == 456.7
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Countries.update_country(country, @invalid_attrs)
      assert country == Countries.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Countries.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Countries.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Countries.change_country(country)
    end
  end
end
