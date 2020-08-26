defmodule TurnosWeb.GuardianTokenView do
  use TurnosWeb, :view
  alias TurnosWeb.GuardianTokenView

  def render("index.json", %{guardian_tokens: guardian_tokens}) do
    %{data: render_many(guardian_tokens, GuardianTokenView, "guardian_token.json")}
  end

  def render("show.json", %{guardian_token: guardian_token}) do
    %{data: render_one(guardian_token, GuardianTokenView, "guardian_token.json")}
  end

  def render("guardian_token.json", %{guardian_token: guardian_token}) do
    %{
      jti: guardian_token.jti,
      aud: guardian_token.aud,
      typ: guardian_token.typ,
      iss: guardian_token.iss,
      sub: guardian_token.sub,
      exp: guardian_token.exp,
      jwt: guardian_token.jwt,
      claims: guardian_token.claims,
      user: render_one(guardian_token.users, TurnosWeb.UserView, "user.json")
    }
  end
end
