defmodule Turnos.Repo.Migrations.CreateConfigHeadersTable do
  use Ecto.Migration

  def change do
    create table(:config_headers) do
      add :user_id, references(:users)
      add :generate_every_days, :integer, default: 30
      add :generate_up_to, :utc_datetime_usec
      add :lastdate, :utc_datetime_usec

      timestamps()

    end
  end
end
