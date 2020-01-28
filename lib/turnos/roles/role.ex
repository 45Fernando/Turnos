defmodule Turnos.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :roleName, :string

    many_to_many(:users, Turnos.Users.User, join_through: "users_roles", on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:roleName])
    |> validate_required([:roleName])
  end
end
