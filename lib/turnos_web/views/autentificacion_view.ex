defmodule TurnosWeb.AutentificacionView do
  use TurnosWeb, :view
  alias TurnosWeb.AutentificacionView

  def render("auth.json", %{user: user, token: jwt, roles: roles}) do
    %{data: %{
      id: user.id,
      name: user.name,
      lastname: user.lastname,
      token: jwt,
      roles: render_many(roles, TurnosWeb.Admin.RoleView, "role.json") #TODO VER SI CAMBIAR ADMIN.CONTROLLER O NO
    }}
  end

end
