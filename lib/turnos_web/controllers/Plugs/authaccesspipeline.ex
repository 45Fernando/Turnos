defmodule TurnosWeb.Plugs.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :turnos

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, ensure: true
end
