defmodule TurnosWeb.Router do
  use TurnosWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :paciente do
    plug TurnosWeb.Plugs.EnsureRolePlug, [:paciente]
  end

  pipeline :proffesional do
    plug TurnosWeb.Plugs.EnsureRolePlug, [:profesional]
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

    resources "/users", Admin.UserController, only: [:create]
    get "/users/:mail", Patient.UserController, :search_by_mail

    #Todo de aca para abajo va a pasar por la autentificacion.
    pipe_through :authenticated

    delete "/identity/callback", AutentificacionController, :delete
    post "/identity/callback", AutentificacionController, :refresh


    resources "/countries", Admin.CountryController, only: [:index] do
      resources "/provinces", Admin.ProvinceController, only: [:index]
    end

    #Todas estas son rutas del usuario
    scope "/patient", as: :patient do
      pipe_through :paciente

      resources "/users", Patient.UserController, except: [:index, :new, :create, :edit, :delete]
      get "/professionals", Patient.UserController, :index_professionals
      get "/professionals/:id", Patient.UserController, :show_professionals
    end

    #TODO organizar lo de los turnos
    resources "/appointments", AppointmentController, except: [:new, :edit]

    #Todas estas son rutas del profesional
    scope "/professional", as: :professional do
      pipe_through :proffesional

      resources "/users", Professional.UserController, except: [:index, :new, :create, :edit, :delete] do
        resources "/config", Professional.ConfigHeaderController, only: [:create]#except: [:new, :edit, :show, :update, :delete]
        get "/config", Professional.ConfigHeaderController, :show
        put "/config", Professional.ConfigHeaderController, :update
        resources "/config/config_details", Professional.ConfigDetailController, except: [:new, :edit]
        resources "/offices_per", Professional.OfficePerController, only: [:index, :create, :show, :update, :delete]
      end


    end

    #Todas estas son rutas de admin
    scope "/admin", as: :admin do
      pipe_through :admin

      resources "/users", Admin.UserController, except: [:new, :create, :edit, :delete] do
        resources "/offices_per", Admin.OfficePerController, except: [:new, :edit]
      end

      put "/users/:user_id/updatepassword", Admin.UserController, :update_password

      put "/users/:user_id/medicalsinsurances", Admin.UserController, :update_medicalsinsurances
      get "/users/:user_id/medicalsinsurances", Admin.UserController, :show_medicalsinsurances

      put "/users/:user_id/roles", Admin.UserController, :update_roles
      get "/users/:user_id/roles", Admin.UserController, :show_roles

      put "/users/:user_id/specialties", Admin.UserController, :update_specialties
      get "/users/:user_id/specialties", Admin.UserController, :show_specialties

      resources "/countries", Admin.CountryController, except: [:new, :edit, :index] do
        resources "/provinces", Admin.ProvinceController, except: [:new, :edit, :index]
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
