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

    timestamps()
  end

  @doc false
  def changeset(office, attrs) do
    office
    |> cast(attrs, [:phone, :name, :address, :status, :lat, :long])
    |> validate_required([:phone, :name, :address, :status, :lat, :long])
  end
end
