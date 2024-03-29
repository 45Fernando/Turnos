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

    get "/users/search_by_mail/:mail", Patient.UserController, :search_by_mail

    resources "/users", UserController, only: [:create]

    # Todo de aca para abajo va a pasar por la autentificacion.
    pipe_through :authenticated

    delete "/identity/callback", AutentificacionController, :delete
    post "/identity/callback", AutentificacionController, :refresh

    resources "/users", UserController, except: [:new, :create, :edit, :delete] do
      resources "/offices_per", OfficePerController, except: [:new, :edit]
      put "/updatepassword", UserController, :update_password

      put "/medicalsinsurances", UserController, :update_medicalsinsurances
      get "/medicalsinsurances", UserController, :show_medicalsinsurances

      put "/roles", UserController, :update_roles
      get "/roles", UserController, :show_roles

      put "/specialties", UserController, :update_specialties
      get "/specialties", UserController, :show_specialties
      resources "/config", ConfigHeaderController, only: [:create, :show, :update]

      resources "/config/config_details", ConfigDetailController, except: [:new, :edit]

      resources "/appointments", AppointmentController, only: [:index, :show, :update]
      post "/appointments/generate", AppointmentController, :generate_appointments
    end

    resources "/specialties", SpecialtyController, except: [:new, :edit, :delete]
    resources "/days", DayController, except: [:new, :create, :edit, :update, :delete]
    resources "/roles", RoleController, except: [:new, :create, :edit, :update, :delete]
    resources "/medicalsinsurances", MedicalInsuranceController, except: [:new, :edit, :delete]
    resources "/offices", OfficeController, except: [:new, :edit]

    resources "/countries", CountryController, except: [:new, :edit, :create, :update, :delete] do
      resources "/provinces", ProvinceController, except: [:new, :edit, :create, :update, :delete]
    end

    # Todas estas son rutas de admin
    scope "/admin", as: :admin do
      get "/tokens", Admin.GuardianTokenController, :index
      delete "/tokens", AutentificacionController, :revoke
    end
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :turnos, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "0.0.3",
        title: "Turnos"
      }
    }
  end
end
