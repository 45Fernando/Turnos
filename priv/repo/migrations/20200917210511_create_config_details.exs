defmodule Turnos.Repo.Migrations.CreateConfigDetails do
  use Ecto.Migration

  def change do
    create table(:config_details) do
      add :minutes_interval, :integer, null: false
      add :start_time, :time_usec, null: false
      add :end_time, :time_usec, null: false
      add :overturn, :boolean, default: false, null: false
      add :quantity_persons_overturn, :integer, default: 0
      add :quantity_persons_per_day, :integer, default: 0

      add :config_header_id, references(:config_headers)
      add :day_id, references(:days)
      add :office_id, references(:offices)
      add :office_per_id, references(:offices_per)

      timestamps()
    end

  end
end
