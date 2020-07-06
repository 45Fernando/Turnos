defmodule TurnosWeb.Admin.GuardianTokenController do
  use TurnosWeb, :controller

  alias Turnos.GuardianTokens
  alias Turnos.GuardianTokens.GuardianToken

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    guardian_tokens = GuardianTokens.list_tokens()
    render(conn, "index.json", guardian_tokens: guardian_tokens)
  end

end
