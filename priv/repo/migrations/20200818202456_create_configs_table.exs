defmodule Turnos.Repo.Migrations.CreateConfigHeadersTable do
  use Ecto.Migration

  def change do
    create table(:config_headers) do
      add :user_id, references(:users)
      add :generate_every_days, :integer, default: 30
      add :generate_up_to, :date
      add :lastdate, :utc_datetime

      timestamps()
      #add :day_id, references(:days)
      #add :office_per_id, references(:offices_per)
      #add :office_id, references(:offices)
      #add :minutes_interval, :integer, null: false
      #add :time_start, :time, null: false
      #add :time_end, :time, null: false
      #add :overturn, :boolean, default: false
      #add :quantity_persons_overturn, :integer, default: 0
      #add :quantity_persons_per_day, :integer, default: 0

    end
  end
end
