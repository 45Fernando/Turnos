defmodule Turnos.ConfigHeaders do
  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.ConfigHeaders.ConfigHeader


  def get_config_by_user(user_id)do
    Repo.get_by!(ConfigHeader, user_id: user_id)
  end


  def create_config(attrs \\ %{}) do
    %ConfigHeader{}
    |> ConfigHeader.changeset(attrs)
    |> Repo.insert()
  end

  def update_config(%ConfigHeader{} = config, attrs) do
    config
    |> ConfigHeader.changeset(attrs)
    |> Repo.update()
  end

  def delete_config(%ConfigHeader{} = config) do
    Repo.delete(config)
  end

end
