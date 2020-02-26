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

    delete "/identity/callback", AutentificacionController, :delete
    post "/identity/callback", AutentificacionController, :refresh

    resources "/users", UserController, except: [:new, :create, :edit, :delete]
    put "/users/:id/updatepassword", UserController, :update_password
    put "/users/:id/medicalsinsurances", UserController, :update_medicalsinsurances
    get "/users/:id/medicalsinsurances", UserController, :show_medicalsinsurances
    put "/users/:id/roles", UserController, :update_roles
    put "/users/:id/specialties", UserController, :update_specialties
    get "/users/:id/specialties", UserController, :show_specialties

    post "/users/:user_id/offices", UserOfficeController, :create_offices
    put "/users/:user_id/offices/:id", UserOfficeController, :update_offices
    get "/users/:user_id/offices/", UserController, :show_offices
    delete "/users/:user_id/offices/:id", UserOfficeController, :delete_office


    resources "/roles", RoleController, except: [:new, :edit, :delete]
    resources "/medicalsinsurances", MedicalInsuranceController, except: [:new, :edit, :delete]

    resources "/offices", OfficeController, except: [:new, :edit, :delete]
    post "/offices/:office_id/days", OfficeDayController, :create_days
    put "/offices/:office_id/days/:id", OfficeDayController, :update_days
    delete "/offices/:office_id/days/:id", OfficeDayController, :delete_days

    resources "/days", DayController, except: [:new, :edit, :delete]
    resources "/specialties", SpecialtyController, except: [:new, :edit, :delete]
  end
end
