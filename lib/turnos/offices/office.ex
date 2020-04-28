defmodule Turnos.Offices.Office do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  #alias Turnos.Repo

  schema "offices" do
    field :address, :string
    field :name, :string
    field :status, :boolean, default: true

    has_many(:officesdays, Turnos.OfficesDays.OfficeDay, foreign_key: :office_id, on_replace: :raise)
    has_many(:usersoffices, Turnos.UsersOffices.UserOffice, foreign_key: :office_id, on_replace: :raise)

    timestamps()
  end

  @doc false
  def changeset(office, attrs) do
    office
    |> cast(attrs, [:name, :address, :status])
    |> validate_required([:name, :address, :status])
  end
end
