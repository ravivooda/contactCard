use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :contact_card_server, ContactCardServer.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :contact_card_server, ContactCardServer.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "contact_card_server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
