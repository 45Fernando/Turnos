defmodule TurnosWeb.Professional.ConfigHeaderController do
  use TurnosWeb, :controller

  alias Turnos.ConfigHeaders
  alias Turnos.ConfigHeaders.ConfigHeader


  action_fallback TurnosWeb.FallbackController

  def show(conn, _params) do
    user = conn |> Guardian.Plug.current_resource()

    config_header = user.id |> Turnos.ConfigHeaders.get_config_by_user()

    conn
    |> put_view(TurnosWeb.ConfigHeaderView)
    |> render("show.json", config_header: config_header)
  end

  def create(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    params = Map.update!(params, "user_id", fn( _data) ->
      user.id
    end)


    with {:ok, %ConfigHeader{} = config_header} <- ConfigHeaders.create_config(params) do
      conn
      |> put_view(TurnosWeb.ConfigHeaderView)
      |> put_status(:created)
      |> put_resp_header("location", Routes.professional_user_config_header_path(conn, :show, config_header.user_id, config_header))
      |> render("show.json", config_header: config_header)
    end
  end



  def update(conn, params) do
    user = conn |> Guardian.Plug.current_resource()

    config_header = user.id |> Turnos.ConfigHeaders.get_config_by_user()

    params = Map.delete(params, "id")
    params = Map.delete(params, "user_id")
    params = Map.put(params, "user_id", user.id)

    with {:ok, %ConfigHeader{} = config_header} <- ConfigHeaders.update_config(config_header, params) do
      conn
      |> put_view(TurnosWeb.ConfigHeaderView)
      |> render("show.json", config_header: config_header)
    end
  end

  #def delete(conn, _params) do
  #  config = conn
  #            |> Guardian.Plug.current_resource()
  #            |> Turnos.ConfigHeaders.get_config_by_user()

  #  with {:ok, %ConfigHeader{}} <- ConfigHeaders.delete_config(config) do
  #    send_resp(conn, :no_content, "")
  #  end
  #end

end
