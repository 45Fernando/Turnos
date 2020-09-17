defmodule Turnos.ConfigDetailsTest do
  use Turnos.DataCase

  alias Turnos.ConfigDetails

  describe "config_details" do
    alias Turnos.ConfigDetails.ConfigDetail

    @valid_attrs %{end_time: ~T[14:00:00], minutes: ~T[14:00:00], overturn: true, quantity_persons_overturn: 42, quantity_persons_per_day: 42, start_time: ~T[14:00:00]}
    @update_attrs %{end_time: ~T[15:01:01], minutes: ~T[15:01:01], overturn: false, quantity_persons_overturn: 43, quantity_persons_per_day: 43, start_time: ~T[15:01:01]}
    @invalid_attrs %{end_time: nil, minutes: nil, overturn: nil, quantity_persons_overturn: nil, quantity_persons_per_day: nil, start_time: nil}

    def config_detail_fixture(attrs \\ %{}) do
      {:ok, config_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ConfigDetails.create_config_detail()

      config_detail
    end

    test "list_config_details/0 returns all config_details" do
      config_detail = config_detail_fixture()
      assert ConfigDetails.list_config_details() == [config_detail]
    end

    test "get_config_detail!/1 returns the config_detail with given id" do
      config_detail = config_detail_fixture()
      assert ConfigDetails.get_config_detail!(config_detail.id) == config_detail
    end

    test "create_config_detail/1 with valid data creates a config_detail" do
      assert {:ok, %ConfigDetail{} = config_detail} = ConfigDetails.create_config_detail(@valid_attrs)
      assert config_detail.end_time == ~T[14:00:00]
      assert config_detail.minutes == ~T[14:00:00]
      assert config_detail.overturn == true
      assert config_detail.quantity_persons_overturn == 42
      assert config_detail.quantity_persons_per_day == 42
      assert config_detail.start_time == ~T[14:00:00]
    end

    test "create_config_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ConfigDetails.create_config_detail(@invalid_attrs)
    end

    test "update_config_detail/2 with valid data updates the config_detail" do
      config_detail = config_detail_fixture()
      assert {:ok, %ConfigDetail{} = config_detail} = ConfigDetails.update_config_detail(config_detail, @update_attrs)
      assert config_detail.end_time == ~T[15:01:01]
      assert config_detail.minutes == ~T[15:01:01]
      assert config_detail.overturn == false
      assert config_detail.quantity_persons_overturn == 43
      assert config_detail.quantity_persons_per_day == 43
      assert config_detail.start_time == ~T[15:01:01]
    end

    test "update_config_detail/2 with invalid data returns error changeset" do
      config_detail = config_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = ConfigDetails.update_config_detail(config_detail, @invalid_attrs)
      assert config_detail == ConfigDetails.get_config_detail!(config_detail.id)
    end

    test "delete_config_detail/1 deletes the config_detail" do
      config_detail = config_detail_fixture()
      assert {:ok, %ConfigDetail{}} = ConfigDetails.delete_config_detail(config_detail)
      assert_raise Ecto.NoResultsError, fn -> ConfigDetails.get_config_detail!(config_detail.id) end
    end

    test "change_config_detail/1 returns a config_detail changeset" do
      config_detail = config_detail_fixture()
      assert %Ecto.Changeset{} = ConfigDetails.change_config_detail(config_detail)
    end
  end
end
