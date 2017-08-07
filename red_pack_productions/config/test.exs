use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :red_pack_productions, RedPackProductions.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# # Configure your database
# config :red_pack_productions, RedPackProductions.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "red_pack_productions_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox
