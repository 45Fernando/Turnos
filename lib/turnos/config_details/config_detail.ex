defmodule Turnos.ConfigDetails.ConfigDetail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "config_details" do
    field :end_time, :time_usec, null: false
    field :minutes_interval, :integer, null: false
    field :overturn, :boolean, default: false
    field :quantity_persons_overturn, :integer, default: 0
    field :quantity_persons_per_day, :integer, default: 0
    field :start_time, :time_usec, null: false

    belongs_to(:config_headers, Turnos.ConfigHeaders.ConfigHeader, foreign_key: :config_header_id)
    belongs_to(:days, Turnos.Days.Day, foreign_key: :day_id)
    belongs_to(:offices, Turnos.Offices.Office, foreign_key: :office_id)
    belongs_to(:offices_per, Turnos.OfficesPer.OfficePer, foreign_key: :office_per_id)

    timestamps()
  end

  @doc false
  def changeset(config_detail, attrs) do
    config_detail
    |> cast(attrs, [:minutes_interval, :start_time, :end_time, :overturn, :quantity_persons_overturn, :quantity_persons_per_day, :config_header_id, :day_id, :office_id, :office_per_id])
    |> validate_required([:minutes_interval, :start_time, :end_time, :overturn])
    |> foreign_key_constraint(:day_id)
    |> foreign_key_constraint(:office_id)
    |> foreign_key_constraint(:office_per_id)
  end
end
