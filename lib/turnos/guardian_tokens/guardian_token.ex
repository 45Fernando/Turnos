defmodule Turnos.GuardianTokens.GuardianToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "guardian_tokens" do
    field :jti, :string, primary_key: true
    field :aud, :string, primary_key: true
    field :typ, :string
    field :iss, :string
    #field :sub, :string #aca se guarda el id del usuario
    field :exp, :integer
    field :jwt, :string  #aca se guarda el token generado
    field :claims, :map

    belongs_to(:users, Turnos.Users.User, foreign_key: :sub)

    timestamps()
  end



  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [])
    |> validate_required([])
  end
end
