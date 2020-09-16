# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :turnos,
  ecto_repos: [Turnos.Repo]

# Configures the endpoint
config :turnos, TurnosWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LN2n83wd3UnDcW71h4pB9ZPafdMo8/G0lVyLq2xr0NRYla8ZachWBH+SiDirZm8r",
  render_errors: [view: TurnosWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Turnos.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

#Configuracion de UerberAuth
config :ueberauth, Ueberauth,
    base_path: "/api/auth",
    providers: [
      identity: {Ueberauth.Strategy.Identity, [
        callback_methods: ["POST"],
        correoelectronico: :mail,
        #param_nesting: "usuario",
        uid_field: :mail
      ]}
    ]

#Configuracion de Guardian
config :turnos, Turnos.Guardian,
    hooks: GuardianDb,
    issuer: "Auth",
    secret_key: "YiCdBySVeRaFe3NYHp40ryepP+7eSaxsJ9WI1bvqQzFFiDcClp0RfY9t/DuKazD+",

    # We will get round to using these permissions at the end
    permissions: %{
      default: [:read_users, :write_users]
    }

# Configure the authentication plug pipeline
config :turnos, TurnosWeb.Plugs.AuthAccessPipeline,
module: Turnos.Guardian,
error_handler: TurnosWeb.Plugs.AuthErrorHandler

config :guardian, Guardian.DB,
  repo: Turnos.Repo, # Add your repository module
  schema_name: "guardian_tokens", # default
  #token_types: ["refresh_token"], # store all token types if not set
  sweep_interval: 120 # default: 60 minutes

config :waffle,
storage: Waffle.Storage.Local, # or Waffle.Storage.S3
storage_dir_prefix: "priv/waffle/public",
#bucket: {:system, "AWS_S3_BUCKET"}, # if using S3
asset_host: "http://localhost:4000" # or {:system, "ASSET_HOST"}

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
