defmodule Turnos.ConfigHeaders.ConfigHeader do
  use Ecto.Schema
  import Ecto.Changeset

  schema "config_headers" do
    belongs_to(:users, Turnos.Users.User, foreign_key: :user_id)
    #belongs_to(:days, Turnos.Days.Day, foreign_key: :day_id)
    #belongs_to(:offices_per, Turnos.OfficesPer.OfficePer, foreign_key: :office_per_id)
    #belongs_to(:offices, Turnos.Offices.Office, foreign_key: :office_id)

    #field :minutes_interval, :integer, null: false
    #field :time_start, :time, null: false
    #field :time_end, :time, null: false
    #field :overturn, :boolean, default: false
    #field :quantity_persons_overturn, :integer, default: 0
    #field :quantity_persons_per_day, :integer, default: 0
    field :generate_every_days, :integer, default: 30
    field :generate_up_to, :date
    field :lastdate, :utc_datetime

    timestamps()
  end

  #@cast_list ~w(user_id day_id office_per_id office_id minutes_interval time_start time_end overturn quantity_persons_overturn
  #quantity_persons_per_day generate_every_days generate_up_to)

  @require_list ~w(user_id)a

  @doc false
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:user_id, :generate_every_days, :generate_up_to, :lastdate])
    |> validate_required(@require_list)
    |> foreign_key_constraint(:user_id)
    #|> foreign_key_constraint(:day_id)
    #|> foreign_key_constraint(:office_per_id)
    #|> foreign_key_constraint(:office_id)
  end

end
