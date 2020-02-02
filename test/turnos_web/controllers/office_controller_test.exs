defmodule TurnosWeb.OfficeControllerTest do
  use TurnosWeb.ConnCase

  alias Turnos.Offices
  alias Turnos.Offices.Office

  @create_attrs %{
    address: "some address",
    name: "some name",
    status: true
  }
  @update_attrs %{
    address: "some updated address",
    name: "some updated name",
    status: false
  }
  @invalid_attrs %{address: nil, name: nil, status: nil}

  def fixture(:office) do
    {:ok, office} = Offices.create_office(@create_attrs)
    office
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all offices", %{conn: conn} do
      conn = get(conn, Routes.office_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create office" do
    test "renders office when data is valid", %{conn: conn} do
      conn = post(conn, Routes.office_path(conn, :create), office: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.office_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some address",
               "name" => "some name",
               "status" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.office_path(conn, :create), office: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update office" do
    setup [:create_office]

    test "renders office when data is valid", %{conn: conn, office: %Office{id: id} = office} do
      conn = put(conn, Routes.office_path(conn, :update, office), office: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.office_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some updated address",
               "name" => "some updated name",
               "status" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, office: office} do
      conn = put(conn, Routes.office_path(conn, :update, office), office: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete office" do
    setup [:create_office]

    test "deletes chosen office", %{conn: conn, office: office} do
      conn = delete(conn, Routes.office_path(conn, :delete, office))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.office_path(conn, :show, office))
      end
    end
  end

  defp create_office(_) do
    office = fixture(:office)
    {:ok, office: office}
  end
end
