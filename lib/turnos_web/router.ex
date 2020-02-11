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



    post "/users", UserController, :create
    #Todo de aca para abajo va a pasar por la autentificacion.
    pipe_through :authenticated

    resources "/users", UserController, except: [:new, :create, :edit, :delete]
    put "/users/:id/updatepassword", UserController, :update_password
    put "/users/:id/medicalsinsurances", UserController, :update_medicalsinsurances
    get "/users/:id/medicalsinsurances", UserController, :show_medicalsinsurances
    put "/users/:id/offices", UserController, :update_offices
    get "/users/:id/offices", UserController, :show_offices
    put "/users/:id/roles", UserController, :update_roles

    resources "/roles", RoleController, except: [:new, :edit, :delete]
    resources "/medicalsinsurances", MedicalInsuranceController, except: [:new, :edit, :delete]
    resources "/offices", OfficeController, except: [:new, :edit, :delete]
  end
end
