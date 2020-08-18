defmodule TurnosWeb.Professional.ConfigController do
  use TurnosWeb, :controller

  alias Turnos.Configs
  alias Turnos.Configs.Config
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def index(conn, params) do
    configs = Turnos.Configs.configs_per_user(params["user_id"])
              |> Repo.all

    render(conn, "index.json", configs: configs)
  end

  def create(conn, params) do
    with {:ok, %Config{} = config} <- Configs.create_config(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.professional_config_path(conn, :show, config))
      |> render("show.json", config: config)
    end
  end

  def show(conn, params) do
    config = Configs.configs_per_user(params["user_id"])
             |> Repo.get!(params["id"])

    conn
    |> render("show.json", config: config)
  end

  def update(conn, params) do
    config = Configs.configs_per_user(params["user_id"])
             |> Repo.get!(params["id"])

    params = Map.delete(params, "id")

    with {:ok, %Config{} = config} <- Configs.update_config(config, params) do
      render(conn, "show.json", config: config)
    end
  end

  def delete(conn, params) do
    config = Configs.configs_per_user(params["user_id"])
             |> Repo.get!(params["id"])

    with {:ok, %Config{}} <- Configs.delete_config(config) do
      send_resp(conn, :no_content, "")
    end
  end

end
