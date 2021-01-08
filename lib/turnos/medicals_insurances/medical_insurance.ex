defmodule Turnos.MedicalsInsurances.MedicalInsurance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "medicalsinsurances" do
    field :businessName, :string
    field :cuit, :string
    field :name, :string
    field :status, :boolean, default: true

    many_to_many(:users, Turnos.Users.User,
      join_through: "users_medicalsinsurances",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(medical_insurance, attrs) do
    medical_insurance
    |> cast(attrs, [:cuit, :name, :businessName, :status])
    |> validate_required([:cuit, :name, :businessName, :status])
  end
end
