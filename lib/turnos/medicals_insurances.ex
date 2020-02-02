defmodule Turnos.MedicalsInsurances do
  @moduledoc """
  The MedicalsInsurances context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.MedicalsInsurances.MedicalInsurance

  @doc """
  Returns the list of medicalsinsurances.

  ## Examples

      iex> list_medicalsinsurances()
      [%MedicalInsurance{}, ...]

  """
  def list_medicalsinsurances do
    Repo.all(MedicalInsurance)
  end

  @doc """
  Gets a single medical_insurance.

  Raises `Ecto.NoResultsError` if the Medical insurance does not exist.

  ## Examples

      iex> get_medical_insurance!(123)
      %MedicalInsurance{}

      iex> get_medical_insurance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_medical_insurance!(id), do: Repo.get!(MedicalInsurance, id)

  @doc """
  Creates a medical_insurance.

  ## Examples

      iex> create_medical_insurance(%{field: value})
      {:ok, %MedicalInsurance{}}

      iex> create_medical_insurance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_medical_insurance(attrs \\ %{}) do
    %MedicalInsurance{}
    |> MedicalInsurance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a medical_insurance.

  ## Examples

      iex> update_medical_insurance(medical_insurance, %{field: new_value})
      {:ok, %MedicalInsurance{}}

      iex> update_medical_insurance(medical_insurance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_medical_insurance(%MedicalInsurance{} = medical_insurance, attrs) do
    medical_insurance
    |> MedicalInsurance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MedicalInsurance.

  ## Examples

      iex> delete_medical_insurance(medical_insurance)
      {:ok, %MedicalInsurance{}}

      iex> delete_medical_insurance(medical_insurance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_medical_insurance(%MedicalInsurance{} = medical_insurance) do
    Repo.delete(medical_insurance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking medical_insurance changes.

  ## Examples

      iex> change_medical_insurance(medical_insurance)
      %Ecto.Changeset{source: %MedicalInsurance{}}

  """
  def change_medical_insurance(%MedicalInsurance{} = medical_insurance) do
    MedicalInsurance.changeset(medical_insurance, %{})
  end
end
