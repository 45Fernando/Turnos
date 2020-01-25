defmodule TurnosWeb.Router do
  use TurnosWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug TurnosWeb.Plugs.AuthAccessPipeline
  end

  scope "/api", TurnosWeb do
    pipe_through :api

    scope "/auth" do
      post "/identity/callback", AutentificacionController, :identity_callback
    end



    post "/usuarios", UsuarioController, :create
    #Todo de aca para abajo va a pasar por la autentificacion.
    pipe_through :authenticated

    resources "/usuarios", UsuarioController, except: [:new, :create, :edit]
  end
end
