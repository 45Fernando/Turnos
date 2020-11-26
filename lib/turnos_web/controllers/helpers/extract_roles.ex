defmodule TurnosWeb.ExtractRoles do
  # only: [halt: 1]
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def extract_roles(user) do
    extract_roles(user.roles, [])
  end

  def extract_roles([h | t], roles) do
    extract_roles(t, [h.roleName | roles])
  end

  def extract_roles([], roles) do
    roles
  end

  def halt_connection(conn) do
    conn
    |> put_status(401)
    |> json(%{message: "Unauthorized access - Unauthorized roles "})
    |> halt()
  end
end
