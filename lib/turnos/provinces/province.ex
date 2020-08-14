defmodule Turnos.Provinces.Province do
  use Ecto.Schema
  import Ecto.Changeset

  schema "provinces" do
    field :code, :string
    field :name, :string

    timestamps()

    belongs_to(:countries, Turnos.Countries.Country, foreign_key: :country_id)
    has_many(:users, Turnos.Users.User, foreign_key: :province_id, on_delete: :nilify_all)
  end

  @doc false
  def changeset(province, attrs) do
    province
    |> cast(attrs, [:name, :code, :country_id])
    |> validate_required([:name, :code])
    |> foreign_key_constraint(:country_id)
  end
end
