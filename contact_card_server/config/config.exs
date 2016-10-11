# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :contact_card_server,
  ecto_repos: [ContactCardServer.Repo]

# Configures the endpoint
config :contact_card_server, ContactCardServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IzfFum0z5mNc6a8pyoMxlb750fnYeqIUL419d+4njHeiSw6djQGJheak9UyGWOzr",
  render_errors: [view: ContactCardServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ContactCardServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
