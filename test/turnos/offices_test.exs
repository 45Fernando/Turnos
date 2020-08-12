defmodule Turnos.OfficesTest do
  use Turnos.DataCase

  alias Turnos.Offices

  describe "offices" do
    alias Turnos.Offices.Office

    @valid_attrs %{address: "some address", name: "some name", status: true}
    @update_attrs %{address: "some updated address", name: "some updated name", status: false}
    @invalid_attrs %{address: nil, name: nil, status: nil}

    def office_fixture(attrs \\ %{}) do
      {:ok, office} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Offices.create_office()

      office
    end

    test "list_offices/0 returns all offices" do
      office = office_fixture()
      assert Offices.list_offices() == [office]
    end

    test "get_office!/1 returns the office with given id" do
      office = office_fixture()
      assert Offices.get_office!(office.id) == office
    end

    test "create_office/1 with valid data creates a office" do
      assert {:ok, %Office{} = office} = Offices.create_office(@valid_attrs)
      assert office.address == "some address"
      assert office.name == "some name"
      assert office.status == true
    end

    test "create_office/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Offices.create_office(@invalid_attrs)
    end

    test "update_office/2 with valid data updates the office" do
      office = office_fixture()
      assert {:ok, %Office{} = office} = Offices.update_office(office, @update_attrs)
      assert office.address == "some updated address"
      assert office.name == "some updated name"
      assert office.status == false
    end

    test "update_office/2 with invalid data returns error changeset" do
      office = office_fixture()
      assert {:error, %Ecto.Changeset{}} = Offices.update_office(office, @invalid_attrs)
      assert office == Offices.get_office!(office.id)
    end

    test "delete_office/1 deletes the office" do
      office = office_fixture()
      assert {:ok, %Office{}} = Offices.delete_office(office)
      assert_raise Ecto.NoResultsError, fn -> Offices.get_office!(office.id) end
    end

    test "change_office/1 returns a office changeset" do
      office = office_fixture()
      assert %Ecto.Changeset{} = Offices.change_office(office)
    end
  end

  describe "offices" do
    alias Turnos.Offices.Office

    @valid_attrs %{address: "some address", lat: "some lat", long: "some long", name: "some name", phone: "some phone", status: true}
    @update_attrs %{address: "some updated address", lat: "some updated lat", long: "some updated long", name: "some updated name", phone: "some updated phone", status: false}
    @invalid_attrs %{address: nil, lat: nil, long: nil, name: nil, phone: nil, status: nil}

    def office_fixture(attrs \\ %{}) do
      {:ok, office} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Offices.create_office()

      office
    end

    test "list_offices/0 returns all offices" do
      office = office_fixture()
      assert Offices.list_offices() == [office]
    end

    test "get_office!/1 returns the office with given id" do
      office = office_fixture()
      assert Offices.get_office!(office.id) == office
    end

    test "create_office/1 with valid data creates a office" do
      assert {:ok, %Office{} = office} = Offices.create_office(@valid_attrs)
      assert office.address == "some address"
      assert office.lat == "some lat"
      assert office.long == "some long"
      assert office.name == "some name"
      assert office.phone == "some phone"
      assert office.status == true
    end

    test "create_office/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Offices.create_office(@invalid_attrs)
    end

    test "update_office/2 with valid data updates the office" do
      office = office_fixture()
      assert {:ok, %Office{} = office} = Offices.update_office(office, @update_attrs)
      assert office.address == "some updated address"
      assert office.lat == "some updated lat"
      assert office.long == "some updated long"
      assert office.name == "some updated name"
      assert office.phone == "some updated phone"
      assert office.status == false
    end

    test "update_office/2 with invalid data returns error changeset" do
      office = office_fixture()
      assert {:error, %Ecto.Changeset{}} = Offices.update_office(office, @invalid_attrs)
      assert office == Offices.get_office!(office.id)
    end

    test "delete_office/1 deletes the office" do
      office = office_fixture()
      assert {:ok, %Office{}} = Offices.delete_office(office)
      assert_raise Ecto.NoResultsError, fn -> Offices.get_office!(office.id) end
    end

    test "change_office/1 returns a office changeset" do
      office = office_fixture()
      assert %Ecto.Changeset{} = Offices.change_office(office)
    end
  end
end
