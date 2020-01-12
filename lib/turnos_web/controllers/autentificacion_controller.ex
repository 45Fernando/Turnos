defmodule TurnosWeb.AutentificacionController do
  use TurnosWeb, :controller

  alias Turnos.Usuarios

  plug Ueberauth

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect(auth, label: "auth")
    correo = auth.uid
    password = auth.credentials.other.password
    handle_user_conn(Usuarios.login_email_password(correo, password), conn)
  end

  defp handle_user_conn(user, conn) do
    case user do
      {:ok, usuario} ->
        {:ok, jwt, _full_claims} =
          Turnos.Guardian.encode_and_sign(usuario, %{})

        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> json(%{data: %{token: jwt}})

      # Handle our own error to keep it generic
      {:error, _reason} ->
        conn
        |> put_status(401)
        |> json(%{message: "user not found"})
    end
  end
end
