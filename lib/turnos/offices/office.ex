defmodule Turnos.Offices.Office do
  use Ecto.Schema
  import Ecto.Changeset

  schema "offices" do
    field :address, :string
    field :lat, :string
    field :long, :string
    field :name, :string
    field :phone, :string
    field :status, :boolean, default: true

    has_many(:config_details, Turnos.ConfigDetails.ConfigDetail, foreign_key: :office_id)
    has_many(:appointments, Turnos.Appointments.Appointment, foreign_key: :office_id)

    timestamps()
  end

  @doc false
  def changeset(office, attrs) do
    office
    |> cast(attrs, [:phone, :name, :address, :status, :lat, :long])
    # luego agregar lat y long
    |> validate_required([:phone, :name, :address, :status])
  end
end
