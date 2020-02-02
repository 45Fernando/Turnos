defmodule Turnos.Offices.Office do
  use Ecto.Schema
  import Ecto.Changeset

  schema "offices" do
    field :address, :string
    field :name, :string
    field :status, :boolean, default: false

    many_to_many(:users, Turnos.Users.User, join_through: "users_offices", on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(office, attrs) do
    office
    |> cast(attrs, [:name, :address, :status])
    |> validate_required([:name, :address, :status])
  end
end
