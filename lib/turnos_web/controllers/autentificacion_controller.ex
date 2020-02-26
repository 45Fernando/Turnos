defmodule TurnosWeb.AutentificacionController do
  use TurnosWeb, :controller

  alias Turnos.Users

  plug Ueberauth

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    correo = auth.uid
    password = auth.credentials.other.password
    handle_user_conn(Users.login_email_password(correo, password), conn)
  end

  #Es el que asigna el token.
  defp handle_user_conn(user, conn) do
    case user do
      {:ok, usuario} ->
        {:ok, jwt, _full_claims} =
          Turnos.Guardian.encode_and_sign(usuario, %{}, ttl: {1, :days})

      conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> render("auth.json", user: usuario, token: jwt, roles: usuario.roles)
        #|> json(%{data: %{token: jwt}})



      # Handle our own error to keep it generic
      {:error, _reason} ->
        conn
        |> put_status(401)
        |> json(%{message: "user not found"})
    end
  end

  def delete(conn, _) do
    conn
    |> Turnos.Guardian.Plug.sign_out()
    |> put_status(:no_content)
    |> render("delete.json")
  end

  def refresh(conn, _params) do
    user = Turnos.Guardian.Plug.current_resource(conn)
    jwt = Turnos.Guardian.Plug.current_token(conn)

    case Turnos.Guardian.refresh(jwt, ttl: {1, :days}) do
      {:ok, _, {new_jwt, _new_claims}} ->
        conn
        |> put_status(:ok)
        |> render("auth.json", user: user, token: new_jwt, roles: user.roles)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", error: "Not Authenticated")
    end
  end

end
