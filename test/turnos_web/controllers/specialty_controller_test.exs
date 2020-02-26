defmodule TurnosWeb.SpecialtyControllerTest do
  use TurnosWeb.ConnCase

  alias Turnos.Specialties
  alias Turnos.Specialties.Specialty

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:specialty) do
    {:ok, specialty} = Specialties.create_specialty(@create_attrs)
    specialty
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all specialties", %{conn: conn} do
      conn = get(conn, Routes.specialty_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create specialty" do
    test "renders specialty when data is valid", %{conn: conn} do
      conn = post(conn, Routes.specialty_path(conn, :create), specialty: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.specialty_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.specialty_path(conn, :create), specialty: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update specialty" do
    setup [:create_specialty]

    test "renders specialty when data is valid", %{conn: conn, specialty: %Specialty{id: id} = specialty} do
      conn = put(conn, Routes.specialty_path(conn, :update, specialty), specialty: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.specialty_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, specialty: specialty} do
      conn = put(conn, Routes.specialty_path(conn, :update, specialty), specialty: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete specialty" do
    setup [:create_specialty]

    test "deletes chosen specialty", %{conn: conn, specialty: specialty} do
      conn = delete(conn, Routes.specialty_path(conn, :delete, specialty))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.specialty_path(conn, :show, specialty))
      end
    end
  end

  defp create_specialty(_) do
    specialty = fixture(:specialty)
    {:ok, specialty: specialty}
  end
end
