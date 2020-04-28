defmodule Turnos.ProvincesTest do
  use Turnos.DataCase

  alias Turnos.Provinces

  describe "provinces" do
    alias Turnos.Provinces.Province

    @valid_attrs %{code: "some code", name: "some name"}
    @update_attrs %{code: "some updated code", name: "some updated name"}
    @invalid_attrs %{code: nil, name: nil}

    def province_fixture(attrs \\ %{}) do
      {:ok, province} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Provinces.create_province()

      province
    end

    test "list_provinces/0 returns all provinces" do
      province = province_fixture()
      assert Provinces.list_provinces() == [province]
    end

    test "get_province!/1 returns the province with given id" do
      province = province_fixture()
      assert Provinces.get_province!(province.id) == province
    end

    test "create_province/1 with valid data creates a province" do
      assert {:ok, %Province{} = province} = Provinces.create_province(@valid_attrs)
      assert province.code == "some code"
      assert province.name == "some name"
    end

    test "create_province/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Provinces.create_province(@invalid_attrs)
    end

    test "update_province/2 with valid data updates the province" do
      province = province_fixture()
      assert {:ok, %Province{} = province} = Provinces.update_province(province, @update_attrs)
      assert province.code == "some updated code"
      assert province.name == "some updated name"
    end

    test "update_province/2 with invalid data returns error changeset" do
      province = province_fixture()
      assert {:error, %Ecto.Changeset{}} = Provinces.update_province(province, @invalid_attrs)
      assert province == Provinces.get_province!(province.id)
    end

    test "delete_province/1 deletes the province" do
      province = province_fixture()
      assert {:ok, %Province{}} = Provinces.delete_province(province)
      assert_raise Ecto.NoResultsError, fn -> Provinces.get_province!(province.id) end
    end

    test "change_province/1 returns a province changeset" do
      province = province_fixture()
      assert %Ecto.Changeset{} = Provinces.change_province(province)
    end
  end
end
