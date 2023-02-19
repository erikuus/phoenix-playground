defmodule LivePlayground.LanguagesTest do
  use LivePlayground.DataCase

  alias LivePlayground.Languages

  describe "language" do
    alias LivePlayground.Languages.Language

    import LivePlayground.LanguagesFixtures

    @invalid_attrs %{countrycode: nil, isofficial: nil, language: nil, percentage: nil}

    test "list_language/0 returns all language" do
      language = language_fixture()
      assert Languages.list_language() == [language]
    end

    test "get_language!/1 returns the language with given id" do
      language = language_fixture()
      assert Languages.get_language!(language.id) == language
    end

    test "create_language/1 with valid data creates a language" do
      valid_attrs = %{countrycode: "some countrycode", isofficial: true, language: "some language", percentage: 120.5}

      assert {:ok, %Language{} = language} = Languages.create_language(valid_attrs)
      assert language.countrycode == "some countrycode"
      assert language.isofficial == true
      assert language.language == "some language"
      assert language.percentage == 120.5
    end

    test "create_language/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Languages.create_language(@invalid_attrs)
    end

    test "update_language/2 with valid data updates the language" do
      language = language_fixture()
      update_attrs = %{countrycode: "some updated countrycode", isofficial: false, language: "some updated language", percentage: 456.7}

      assert {:ok, %Language{} = language} = Languages.update_language(language, update_attrs)
      assert language.countrycode == "some updated countrycode"
      assert language.isofficial == false
      assert language.language == "some updated language"
      assert language.percentage == 456.7
    end

    test "update_language/2 with invalid data returns error changeset" do
      language = language_fixture()
      assert {:error, %Ecto.Changeset{}} = Languages.update_language(language, @invalid_attrs)
      assert language == Languages.get_language!(language.id)
    end

    test "delete_language/1 deletes the language" do
      language = language_fixture()
      assert {:ok, %Language{}} = Languages.delete_language(language)
      assert_raise Ecto.NoResultsError, fn -> Languages.get_language!(language.id) end
    end

    test "change_language/1 returns a language changeset" do
      language = language_fixture()
      assert %Ecto.Changeset{} = Languages.change_language(language)
    end
  end
end
