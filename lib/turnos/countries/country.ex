defmodule Turnos.Countries.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "countries" do
    field :code, :string
    field :name, :string

    timestamps()

    has_many(:users, Turnos.Users.User, foreign_key: :countries_id)
    has_many(:provinces, Turnos.Provinces.Province, foreign_key: :countries_id)
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
  end
end
