defmodule Turnos.Days.Day do
  use Ecto.Schema
  import Ecto.Changeset

  schema "days" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(day, attrs) do
    day
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
