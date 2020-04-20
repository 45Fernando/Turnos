defmodule Turnos.Repo.Migrations.GuardianDb do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:guardian_tokens, primary_key: false) do
      add :jti, :string, primary_key: true
      add :aud, :string, primary_key: true
      add :typ, :string
      add :iss, :string
      add :sub, :string #aca se guarda el id del usuario
      add :exp, :bigint
      add :jwt, :text   #aca se guarda el token generado
      add :claims, :map

      timestamps()
    end

    create index(:guardian_tokens, [:jwt])
    create index(:guardian_tokens, [:sub])
    create index(:guardian_tokens, [:jti])
  end
end
