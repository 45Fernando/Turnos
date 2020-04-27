defmodule Turnos.UsersOffices.UserOffice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_offices" do
    field :timeFrom, :time
    field :timeTo, :time

    belongs_to(:users, Turnos.Users.User, foreign_key: :user_id, on_replace: :raise)
    belongs_to(:offices, Turnos.Offices.Office, foreign_key: :office_id, on_replace: :raise)
    belongs_to(:days, Turnos.Days.Day, foreign_key: :day_id, on_replace: :raise)

    timestamps()
  end

  @doc false
  def changeset(useroffice, attrs) do
    useroffice
    |> cast(attrs, [:user_id, :office_id, :day_id, :timeFrom, :timeTo])
    |> validate_required([:timeFrom, :timeTo])
    |> assoc_constraint(:days)
    |> assoc_constraint(:offices)
    |> assoc_constraint(:users)
  end

end
