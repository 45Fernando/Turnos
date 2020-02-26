defmodule Turnos.Specialties.Specialty do
  use Ecto.Schema
  import Ecto.Changeset

  schema "specialties" do
    field :name, :string

    many_to_many(:users, Turnos.Users.User, join_through: "users_specialties", on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(specialty, attrs) do
    specialty
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
