defmodule TurnosWeb.MedicalInsuranceController do
  use TurnosWeb, :controller

  alias Turnos.MedicalsInsurances
  alias Turnos.MedicalsInsurances.MedicalInsurance

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    medicalsinsurances = MedicalsInsurances.list_medicalsinsurances()
    render(conn, "index.json", medicalsinsurances: medicalsinsurances)
  end

  def create(conn, medical_insurance_params) do
    with {:ok, %MedicalInsurance{} = medical_insurance} <- MedicalsInsurances.create_medical_insurance(medical_insurance_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.medical_insurance_path(conn, :show, medical_insurance))
      |> render("show.json", medical_insurance: medical_insurance)
    end
  end

  def show(conn, %{"id" => id}) do
    medical_insurance = MedicalsInsurances.get_medical_insurance!(id)
    render(conn, "show.json", medical_insurance: medical_insurance)
  end

  def update(conn, medical_insurance_params) do
    id = medical_insurance_params["id"]
    medical_insurance = MedicalsInsurances.get_medical_insurance!(id)
    medical_insurance_params = Map.delete(medical_insurance_params, "id")

    with {:ok, %MedicalInsurance{} = medical_insurance} <- MedicalsInsurances.update_medical_insurance(medical_insurance, medical_insurance_params) do
      render(conn, "show.json", medical_insurance: medical_insurance)
    end
  end

  def delete(conn, %{"id" => id}) do
    medical_insurance = MedicalsInsurances.get_medical_insurance!(id)

    with {:ok, %MedicalInsurance{}} <- MedicalsInsurances.delete_medical_insurance(medical_insurance) do
      send_resp(conn, :no_content, "")
    end
  end
end
