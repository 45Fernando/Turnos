defmodule TurnosWeb.Router do
  use TurnosWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :proffesional do
    plug TurnosWeb.Plugs.EnsureRolePlug, [:proffesional]
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
    get "/users/:mail", UserController, :search_by_mail

    #Todo de aca para abajo va a pasar por la autentificacion.
    pipe_through :authenticated

    delete "/identity/callback", AutentificacionController, :delete
    post "/identity/callback", AutentificacionController, :refresh

    #Todas estas son rutas del usuario

    #Todas estas son rutas del profesional
    pipe_through :proffesional

    scope "/professional", as: :professional do
      resources "/config", Professional.ConfigController, except: [:new, :edit]
    end

    #Todas estas son rutas de admin
    pipe_through :admin

    scope "/admin", as: :admin do
      resources "/users", Admin.UserController, except: [:new, :create, :edit, :delete] do
        resources "/offices_per", Admin.OfficePerController, except: [:new, :edit]
      end

      put "/users/:id/updatepassword", Admin.UserController, :update_password#TODO duda si tiene que tener su admin
      put "/users/:id/medicalsinsurances", Admin.UserController, :update_medicalsinsurances
      get "/users/:id/medicalsinsurances", Admin.UserController, :show_medicalsinsurances
      put "/users/:id/roles", Admin.UserController, :update_roles
      put "/users/:id/specialties", Admin.UserController, :update_specialties
      get "/users/:id/specialties", Admin.UserController, :show_specialties

      resources "/countries", Admin.CountryController, except: [:new, :edit] do
        resources "/provinces", Admin.ProvinceController, except: [:new, :edit]
      end

      resources "/roles", Admin.RoleController, except: [:new, :create, :edit, :delete]
      resources "/medicalsinsurances", Admin.MedicalInsuranceController, except: [:new, :edit, :delete]

      resources "/offices", Admin.OfficeController, except: [:new, :edit]

      resources "/days", Admin.DayController, except: [:new, :create, :edit, :update, :delete]
      resources "/specialties", Admin.SpecialtyController, except: [:new, :edit, :delete]

      get "/tokens", Admin.GuardianTokenController, :index
      delete "/tokens", AutentificacionController, :revoke
    end

  end
end
