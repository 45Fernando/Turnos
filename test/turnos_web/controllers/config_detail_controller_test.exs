defmodule TurnosWeb.ConfigDetailControllerTest do
  use TurnosWeb.ConnCase

  alias Turnos.ConfigDetails
  alias Turnos.ConfigDetails.ConfigDetail

  @create_attrs %{
    end_time: ~T[14:00:00],
    minutes: ~T[14:00:00],
    overturn: true,
    quantity_persons_overturn: 42,
    quantity_persons_per_day: 42,
    start_time: ~T[14:00:00]
  }
  @update_attrs %{
    end_time: ~T[15:01:01],
    minutes: ~T[15:01:01],
    overturn: false,
    quantity_persons_overturn: 43,
    quantity_persons_per_day: 43,
    start_time: ~T[15:01:01]
  }
  @invalid_attrs %{end_time: nil, minutes: nil, overturn: nil, quantity_persons_overturn: nil, quantity_persons_per_day: nil, start_time: nil}

  def fixture(:config_detail) do
    {:ok, config_detail} = ConfigDetails.create_config_detail(@create_attrs)
    config_detail
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all config_details", %{conn: conn} do
      conn = get(conn, Routes.config_detail_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create config_detail" do
    test "renders config_detail when data is valid", %{conn: conn} do
      conn = post(conn, Routes.config_detail_path(conn, :create), config_detail: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.config_detail_path(conn, :show, id))

      assert %{
               "id" => id,
               "end_time" => "14:00:00",
               "minutes" => "14:00:00",
               "overturn" => true,
               "quantity_persons_overturn" => 42,
               "quantity_persons_per_day" => 42,
               "start_time" => "14:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.config_detail_path(conn, :create), config_detail: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update config_detail" do
    setup [:create_config_detail]

    test "renders config_detail when data is valid", %{conn: conn, config_detail: %ConfigDetail{id: id} = config_detail} do
      conn = put(conn, Routes.config_detail_path(conn, :update, config_detail), config_detail: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.config_detail_path(conn, :show, id))

      assert %{
               "id" => id,
               "end_time" => "15:01:01",
               "minutes" => "15:01:01",
               "overturn" => false,
               "quantity_persons_overturn" => 43,
               "quantity_persons_per_day" => 43,
               "start_time" => "15:01:01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, config_detail: config_detail} do
      conn = put(conn, Routes.config_detail_path(conn, :update, config_detail), config_detail: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete config_detail" do
    setup [:create_config_detail]

    test "deletes chosen config_detail", %{conn: conn, config_detail: config_detail} do
      conn = delete(conn, Routes.config_detail_path(conn, :delete, config_detail))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.config_detail_path(conn, :show, config_detail))
      end
    end
  end

  defp create_config_detail(_) do
    config_detail = fixture(:config_detail)
    {:ok, config_detail: config_detail}
  end
end
