defmodule TurnosWeb.AutentificacionView do
  use TurnosWeb, :view
  alias TurnosWeb.AutentificacionView

  def render("auth.json", %{user: user, token: jwt}) do
    %{
      id: user.id,
      name: user.name,
      lastname: user.lastname,
      token: jwt
    }
  end

end
