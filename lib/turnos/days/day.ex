defmodule Turnos.Days.Day do
  use Ecto.Schema
  import Ecto.Changeset

  schema "days" do
    field :name, :string

    has_many(:daysoffices, Turnos.OfficesDays.OfficeDay, foreign_key: :day_id, on_replace: :delete)
    has_many(:usersoffices, Turnos.UsersOffices.UserOffice, foreign_key: :day_id, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(day, attrs) do
    day
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
