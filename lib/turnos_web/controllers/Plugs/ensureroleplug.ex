defmodule TurnosWeb.Plugs.EnsureRolePlug do
  @moduledoc """
  This plug ensures that a user has a particular role.

  ## Example

      plug TurnosWeb.Plugs.EnsureRolePlug, [:user, :admin]

      plug TurnosWeb.Plugs.EnsureRolePlug, :admin

      plug TurnosWeb.Plugs.EnsureRolePlug, ~w(user admin)a
  """
  import Plug.Conn #only: [halt: 1]
  import Phoenix.Controller, only: [json: 2]

  alias TurnosWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller
  #alias Plug.Conn
  #alias Pow.Plug


  def init(config), do: config

  def call(conn, roles) do
    conn
    |> Guardian.Plug.current_resource()
    |> has_role?(roles)
    |> maybe_halt(conn)
  end

  defp has_role?(nil, _roles), do: false
  defp has_role?(user, roles) do
    userRoles = extract_roles(user)

    Enum.any?(roles, fn x -> Atom.to_string(x) in userRoles end)
  end

  defp maybe_halt(true, conn), do: conn
  defp maybe_halt(_any, conn) do
    conn
    |> put_status(401)
    |> json(%{message: "Unauthorized access - Unauthorized roles "})
    |> halt()
  end

  #Funcion para poner los roles en un mapa,
  defp extract_roles(user) do
    extract_roles(user.roles, [])
  end

  defp extract_roles([h | t], roles) do
    extract_roles(t, [h.roleName | roles])
  end

  defp extract_roles([], roles) do
    roles
  end
end
