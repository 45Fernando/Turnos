defmodule Turnos.MedicalsInsurancesTest do
  use Turnos.DataCase

  alias Turnos.MedicalsInsurances

  describe "medicalsinsurances" do
    alias Turnos.MedicalsInsurances.MedicalInsurance

    @valid_attrs %{businessName: "some businessName", cuit: "some cuit", name: "some name"}
    @update_attrs %{businessName: "some updated businessName", cuit: "some updated cuit", name: "some updated name"}
    @invalid_attrs %{businessName: nil, cuit: nil, name: nil}

    def medical_insurance_fixture(attrs \\ %{}) do
      {:ok, medical_insurance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MedicalsInsurances.create_medical_insurance()

      medical_insurance
    end

    test "list_medicalsinsurances/0 returns all medicalsinsurances" do
      medical_insurance = medical_insurance_fixture()
      assert MedicalsInsurances.list_medicalsinsurances() == [medical_insurance]
    end

    test "get_medical_insurance!/1 returns the medical_insurance with given id" do
      medical_insurance = medical_insurance_fixture()
      assert MedicalsInsurances.get_medical_insurance!(medical_insurance.id) == medical_insurance
    end

    test "create_medical_insurance/1 with valid data creates a medical_insurance" do
      assert {:ok, %MedicalInsurance{} = medical_insurance} = MedicalsInsurances.create_medical_insurance(@valid_attrs)
      assert medical_insurance.businessName == "some businessName"
      assert medical_insurance.cuit == "some cuit"
      assert medical_insurance.name == "some name"
    end

    test "create_medical_insurance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MedicalsInsurances.create_medical_insurance(@invalid_attrs)
    end

    test "update_medical_insurance/2 with valid data updates the medical_insurance" do
      medical_insurance = medical_insurance_fixture()
      assert {:ok, %MedicalInsurance{} = medical_insurance} = MedicalsInsurances.update_medical_insurance(medical_insurance, @update_attrs)
      assert medical_insurance.businessName == "some updated businessName"
      assert medical_insurance.cuit == "some updated cuit"
      assert medical_insurance.name == "some updated name"
    end

    test "update_medical_insurance/2 with invalid data returns error changeset" do
      medical_insurance = medical_insurance_fixture()
      assert {:error, %Ecto.Changeset{}} = MedicalsInsurances.update_medical_insurance(medical_insurance, @invalid_attrs)
      assert medical_insurance == MedicalsInsurances.get_medical_insurance!(medical_insurance.id)
    end

    test "delete_medical_insurance/1 deletes the medical_insurance" do
      medical_insurance = medical_insurance_fixture()
      assert {:ok, %MedicalInsurance{}} = MedicalsInsurances.delete_medical_insurance(medical_insurance)
      assert_raise Ecto.NoResultsError, fn -> MedicalsInsurances.get_medical_insurance!(medical_insurance.id) end
    end

    test "change_medical_insurance/1 returns a medical_insurance changeset" do
      medical_insurance = medical_insurance_fixture()
      assert %Ecto.Changeset{} = MedicalsInsurances.change_medical_insurance(medical_insurance)
    end
  end
end
