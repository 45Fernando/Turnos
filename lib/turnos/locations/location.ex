defmodule Turnos.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :code, :string
    field :latitude, :string
    field :longitude, :string
    field :name, :string

    timestamps()

    belongs_to(:provinces, Turnos.Provinces.Province, foreign_key: :province_id)
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :code, :latitude, :longitude, :location_id])
    |> validate_required([:name, :code, :latitude, :longitude])
    |> foreign_key_constraint(:location_id)
  end
end
