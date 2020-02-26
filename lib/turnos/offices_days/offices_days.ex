defmodule Turnos.OfficesDays.OfficeDay do
  use Ecto.Schema
  import Ecto.Changeset

  schema "offices_days" do
    field :timeFrom, :time
    field :timeTo, :time

    belongs_to(:offices, Turnos.Offices.Office, foreign_key: :office_id, on_replace: :raise)
    belongs_to(:days, Turnos.Days.Day, foreign_key: :day_id, on_replace: :raise)

    timestamps()
  end

  @doc false
  def changeset(officeday, attrs) do
    officeday
    |> cast(attrs, [:office_id, :day_id, :timeFrom, :timeTo])
    |> validate_required([:timeFrom, :timeTo])
    |> assoc_constraint(:days)
    |> assoc_constraint(:offices)
  end
end
