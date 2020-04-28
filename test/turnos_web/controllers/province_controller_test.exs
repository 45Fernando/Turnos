defmodule TurnosWeb.ProvinceControllerTest do
  use TurnosWeb.ConnCase

  alias Turnos.Provinces
  alias Turnos.Provinces.Province

  @create_attrs %{
    code: "some code",
    name: "some name"
  }
  @update_attrs %{
    code: "some updated code",
    name: "some updated name"
  }
  @invalid_attrs %{code: nil, name: nil}

  def fixture(:province) do
    {:ok, province} = Provinces.create_province(@create_attrs)
    province
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all provinces", %{conn: conn} do
      conn = get(conn, Routes.province_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create province" do
    test "renders province when data is valid", %{conn: conn} do
      conn = post(conn, Routes.province_path(conn, :create), province: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.province_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some code",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.province_path(conn, :create), province: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update province" do
    setup [:create_province]

    test "renders province when data is valid", %{conn: conn, province: %Province{id: id} = province} do
      conn = put(conn, Routes.province_path(conn, :update, province), province: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.province_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some updated code",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, province: province} do
      conn = put(conn, Routes.province_path(conn, :update, province), province: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete province" do
    setup [:create_province]

    test "deletes chosen province", %{conn: conn, province: province} do
      conn = delete(conn, Routes.province_path(conn, :delete, province))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.province_path(conn, :show, province))
      end
    end
  end

  defp create_province(_) do
    province = fixture(:province)
    {:ok, province: province}
  end
end
