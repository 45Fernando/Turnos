defmodule TurnosWeb.Router do
  use TurnosWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TurnosWeb do
    pipe_through :api

    resources "/usuarios", UsuarioController, except: [:new, :edit]
  end
end
