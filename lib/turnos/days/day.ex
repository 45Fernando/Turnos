defmodule Turnos.Days.Day do
  use Ecto.Schema
  import Ecto.Changeset

  schema "days" do
    field :name, :string

    has_many(:configs, Turnos.Configs.Config, foreign_key: :day_id)

    timestamps()
  end

  @doc false
  def changeset(day, attrs) do
    day
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
