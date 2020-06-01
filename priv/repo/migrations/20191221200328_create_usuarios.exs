defmodule Turnos.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :lastname, :string
      add :dni, :string
      add :mail, :string
      add :address, :string
      add :professionalAddress, :string
      add :password_hash, :string
      add :phoneNumber, :string
      add :professionalPhoneNumber, :string
      add :mobilePhoneNumber, :string
      add :profilePicture, :string
      add :status, :boolean, default: true, null: false
      add :birthDate, :date
      add :cuil, :string
      add :nationalRegistration, :string
      add :provincialRegistration, :string
      add :avatar, :string

      timestamps()
    end

  end
end
