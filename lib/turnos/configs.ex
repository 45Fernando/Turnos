defmodule Turnos.Configs do
  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.Configs.Config

  def configs_per_user(user_id)do
    user_id
    |> Turnos.Users.get_user!()
    |> Ecto.assoc(:configs)
  end


  def create_config(attrs \\ %{}) do
    %Config{}
    |> Config.changeset(attrs)
    |> Repo.insert()
  end

  def update_config(%Config{} = config, attrs) do
    config
    |> Config.changeset(attrs)
    |> Repo.update()
  end

  def delete_config(%Config{} = config) do
    Repo.delete(config)
  end

end
