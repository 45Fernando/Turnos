defmodule TurnosWeb.DayControllerTest do
  use TurnosWeb.ConnCase

  alias Turnos.Days
  alias Turnos.Days.Day

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:day) do
    {:ok, day} = Days.create_day(@create_attrs)
    day
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all days", %{conn: conn} do
      conn = get(conn, Routes.day_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create day" do
    test "renders day when data is valid", %{conn: conn} do
      conn = post(conn, Routes.day_path(conn, :create), day: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.day_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.day_path(conn, :create), day: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update day" do
    setup [:create_day]

    test "renders day when data is valid", %{conn: conn, day: %Day{id: id} = day} do
      conn = put(conn, Routes.day_path(conn, :update, day), day: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.day_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, day: day} do
      conn = put(conn, Routes.day_path(conn, :update, day), day: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete day" do
    setup [:create_day]

    test "deletes chosen day", %{conn: conn, day: day} do
      conn = delete(conn, Routes.day_path(conn, :delete, day))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.day_path(conn, :show, day))
      end
    end
  end

  defp create_day(_) do
    day = fixture(:day)
    {:ok, day: day}
  end
end
