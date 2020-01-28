defmodule TurnosWeb.AutentificacionController do
  use TurnosWeb, :controller

  alias Turnos.Users

  plug Ueberauth

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    #IO.inspect(auth, label: "auth")
    correo = auth.uid
    password = auth.credentials.other.password
    handle_user_conn(Users.login_email_password(correo, password), conn)
  end

  #Es el que asigna el token.
  defp handle_user_conn(user, conn) do
    case user do
      {:ok, usuario} ->
        {:ok, jwt, _full_claims} =
          Turnos.Guardian.encode_and_sign(usuario, %{})

      conn =
        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        #|> json(%{data: %{token: jwt}})

      render(conn, "auth.json", user: usuario, token: jwt)

      # Handle our own error to keep it generic
      {:error, _reason} ->
        conn
        |> put_status(401)
        |> json(%{message: "user not found"})
    end
  end
end
