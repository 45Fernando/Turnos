defmodule TurnosWeb.Router do
  use TurnosWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug TurnosWeb.Plugs.EnsureRolePlug, [:admin]
  end

  pipeline :authenticated do
    plug TurnosWeb.Plugs.AuthAccessPipeline
  end

  scope "/api", TurnosWeb do
    pipe_through :api

    scope "/auth" do
      post "/identity/callback", AutentificacionController, :identity_callback
    end

    post "/users", Admin.UserController, :create
    #Todo de aca para abajo va a pasar por la autentificacion.
    pipe_through :authenticated

    delete "/identity/callback", AutentificacionController, :delete
    post "/identity/callback", AutentificacionController, :refresh

    #Todas estas son rutas de admin
    pipe_through :admin

    scope "/admin", as: :admin do
      resources "/users", Admin.UserController, except: [:new, :create, :edit, :delete]
      put "/users/:id/updatepassword", Admin.UserController, :update_password#TODO duda si tiene que tener su admin
      put "/users/:id/medicalsinsurances", Admin.UserController, :update_medicalsinsurances
      get "/users/:id/medicalsinsurances", Admin.UserController, :show_medicalsinsurances
      put "/users/:id/roles", Admin.UserController, :update_roles
      put "/users/:id/specialties", Admin.UserController, :update_specialties
      get "/users/:id/specialties", Admin.UserController, :show_specialties

      post "/users/:user_id/offices", UserOfficeController, :create_offices
      put "/users/:user_id/offices/:id", UserOfficeController, :update_offices
      get "/users/:user_id/offices/", Admin.UserController, :show_offices
      delete "/users/:user_id/offices/:id", UserOfficeController, :delete_office

      resources "/countries", Admin.CountryController, except: [:new, :edit]
      resources "/provinces", Admin.ProvinceController, except: [:new, :edit]
      resources "/locations", Admin.LocationController, except: [:new, :edit]
      resources "/roles", Admin.RoleController, except: [:new, :create, :edit, :delete]
      resources "/medicalsinsurances", Admin.MedicalInsuranceController, except: [:new, :edit, :delete]

      resources "/offices", Admin.OfficeController, except: [:new, :edit, :delete]
      post "/offices/:office_id/days", OfficeDayController, :create_days
      put "/offices/:office_id/days/:id", OfficeDayController, :update_days
      delete "/offices/:office_id/days/:id", OfficeDayController, :delete_days

      resources "/days", Admin.DayController, except: [:new, :create, :edit, :update, :delete]
      resources "/specialties", Admin.SpecialtyController, except: [:new, :edit, :delete]
    end

  end
end
