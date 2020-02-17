defmodule Turnos.Offices.Office do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Turnos.Repo

  schema "offices" do
    field :address, :string
    field :name, :string
    field :status, :boolean, default: false

    many_to_many(:users, Turnos.Users.User, join_through: "users_offices", on_replace: :delete)
    has_many(:officesdays, Turnos.OfficesDays.OfficeDay, foreign_key: :office_id, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(office, attrs) do
    office
    |> Repo.preload(:officesdays)
    |> cast(attrs, [:name, :address, :status])
    |> validate_required([:name, :address, :status])
    |> cast_assoc(:officesdays,  with: &Turnos.OfficesDays.OfficeDay.changeset/2)
  end
end
