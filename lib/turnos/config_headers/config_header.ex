defmodule Turnos.ConfigHeaders.ConfigHeader do
  use Ecto.Schema
  import Ecto.Changeset

  schema "config_headers" do

    field :generate_every_days, :integer, default: 30
    field :generate_up_to, :date
    field :lastdate, :utc_datetime

    belongs_to(:users, Turnos.Users.User, foreign_key: :user_id)
    has_many(:config_details, Turnos.ConfigDetails.ConfigDetail, foreign_key: :config_header_id)

    timestamps()

  end



  @require_list ~w(user_id)a

  @doc false
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:user_id, :generate_every_days, :generate_up_to, :lastdate])
    |> validate_required(@require_list)
    |> foreign_key_constraint(:user_id)
  end

end
