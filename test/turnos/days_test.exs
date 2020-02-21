defmodule Turnos.DaysTest do
  use Turnos.DataCase

  alias Turnos.Days

  describe "days" do
    alias Turnos.Days.Day

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def day_fixture(attrs \\ %{}) do
      {:ok, day} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Days.create_day()

      day
    end

    test "list_days/0 returns all days" do
      day = day_fixture()
      assert Days.list_days() == [day]
    end

    test "get_day!/1 returns the day with given id" do
      day = day_fixture()
      assert Days.get_day!(day.id) == day
    end

    test "create_day/1 with valid data creates a day" do
      assert {:ok, %Day{} = day} = Days.create_day(@valid_attrs)
      assert day.name == "some name"
    end

    test "create_day/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Days.create_day(@invalid_attrs)
    end

    test "update_day/2 with valid data updates the day" do
      day = day_fixture()
      assert {:ok, %Day{} = day} = Days.update_day(day, @update_attrs)
      assert day.name == "some updated name"
    end

    test "update_day/2 with invalid data returns error changeset" do
      day = day_fixture()
      assert {:error, %Ecto.Changeset{}} = Days.update_day(day, @invalid_attrs)
      assert day == Days.get_day!(day.id)
    end

    test "delete_day/1 deletes the day" do
      day = day_fixture()
      assert {:ok, %Day{}} = Days.delete_day(day)
      assert_raise Ecto.NoResultsError, fn -> Days.get_day!(day.id) end
    end

    test "change_day/1 returns a day changeset" do
      day = day_fixture()
      assert %Ecto.Changeset{} = Days.change_day(day)
    end
  end
end
