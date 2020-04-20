defmodule TurnosWeb.Admin.MedicalInsuranceView do
  use TurnosWeb, :view
  alias TurnosWeb.Admin.MedicalInsuranceView

  def render("index.json", %{medicalsinsurances: medicalsinsurances}) do
    %{data: render_many(medicalsinsurances, MedicalInsuranceView, "medical_insurance.json")}
  end

  def render("show.json", %{medical_insurance: medical_insurance}) do
    %{data: render_one(medical_insurance, MedicalInsuranceView, "medical_insurance.json")}
  end

  def render("medical_insurance.json", %{medical_insurance: medical_insurance}) do
    %{id: medical_insurance.id,
      cuit: medical_insurance.cuit,
      name: medical_insurance.name,
      businessName: medical_insurance.businessName,
      status: medical_insurance.status}
  end
end
