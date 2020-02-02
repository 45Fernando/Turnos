defmodule TurnosWeb.MedicalInsuranceControllerTest do
  use TurnosWeb.ConnCase

  alias Turnos.MedicalsInsurances
  alias Turnos.MedicalsInsurances.MedicalInsurance

  @create_attrs %{
    businessName: "some businessName",
    cuit: "some cuit",
    name: "some name"
  }
  @update_attrs %{
    businessName: "some updated businessName",
    cuit: "some updated cuit",
    name: "some updated name"
  }
  @invalid_attrs %{businessName: nil, cuit: nil, name: nil}

  def fixture(:medical_insurance) do
    {:ok, medical_insurance} = MedicalsInsurances.create_medical_insurance(@create_attrs)
    medical_insurance
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all medicalsinsurances", %{conn: conn} do
      conn = get(conn, Routes.medical_insurance_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create medical_insurance" do
    test "renders medical_insurance when data is valid", %{conn: conn} do
      conn = post(conn, Routes.medical_insurance_path(conn, :create), medical_insurance: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.medical_insurance_path(conn, :show, id))

      assert %{
               "id" => id,
               "businessName" => "some businessName",
               "cuit" => "some cuit",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.medical_insurance_path(conn, :create), medical_insurance: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update medical_insurance" do
    setup [:create_medical_insurance]

    test "renders medical_insurance when data is valid", %{conn: conn, medical_insurance: %MedicalInsurance{id: id} = medical_insurance} do
      conn = put(conn, Routes.medical_insurance_path(conn, :update, medical_insurance), medical_insurance: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.medical_insurance_path(conn, :show, id))

      assert %{
               "id" => id,
               "businessName" => "some updated businessName",
               "cuit" => "some updated cuit",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, medical_insurance: medical_insurance} do
      conn = put(conn, Routes.medical_insurance_path(conn, :update, medical_insurance), medical_insurance: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete medical_insurance" do
    setup [:create_medical_insurance]

    test "deletes chosen medical_insurance", %{conn: conn, medical_insurance: medical_insurance} do
      conn = delete(conn, Routes.medical_insurance_path(conn, :delete, medical_insurance))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.medical_insurance_path(conn, :show, medical_insurance))
      end
    end
  end

  defp create_medical_insurance(_) do
    medical_insurance = fixture(:medical_insurance)
    {:ok, medical_insurance: medical_insurance}
  end
end
