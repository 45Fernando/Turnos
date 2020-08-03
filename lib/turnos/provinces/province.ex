defmodule Turnos.Provinces.Province do
  use Ecto.Schema
  import Ecto.Changeset

  schema "provinces" do
    field :code, :string
    field :name, :string

    timestamps()

    belongs_to(:countries, Turnos.Countries.Country, foreign_key: :countries_id)
    has_many(:users, Turnos.Users.User, foreign_key: :province_id)
  end

  @doc false
  def changeset(province, attrs) do
    province
    |> cast(attrs, [:name, :code, :countries_id])
    |> validate_required([:name, :code])
    |> foreign_key_constraint(:countries_id)
  end
end
