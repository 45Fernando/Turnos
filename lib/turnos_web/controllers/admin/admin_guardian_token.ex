defmodule TurnosWeb.Admin.GuardianTokenController do
  use TurnosWeb, :controller

  alias Turnos.GuardianTokens

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    guardian_tokens = GuardianTokens.list_tokens()

    conn
    |> put_view(TurnosWeb.GuardianTokenView)
    |> render("index.json", guardian_tokens: guardian_tokens)
  end

end
