defmodule Turnos.OfficesPer.OfficePer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  #alias Turnos.Repo

  schema "offices_per" do
    field :address, :string
    field :name, :string
    field :status, :boolean, default: true
    field :phone, :string
    field :lat, :string
    field :long, :string

    belongs_to :users, Turnos.Users.User, foreign_key: :user_id
    has_many(:configs, Turnos.Configs.Config, foreign_key: :office_per_id)

    timestamps()
  end

  @doc false
  def changeset(office_per, attrs) do
    office_per
    |> cast(attrs, [:name, :address, :status, :phone, :lat, :long, :user_id])
    |> validate_required([:name, :address, :status, :phone, :lat, :long])
    |> foreign_key_constraint(:user_id)
  end
end
