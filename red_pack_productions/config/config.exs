# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :red_pack_productions,
  ecto_repos: [RedPackProductions.Repo]

# Configures the endpoint
config :red_pack_productions, RedPackProductions.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9nRRDfDaHMN+8w2oQYUyENzd/F/ErpUwyBqbC0EEW8l4VydjeM3fIW9Q/IWK6leN",
  render_errors: [view: RedPackProductions.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RedPackProductions.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# A3-QFGAJ8-DRL2P5-WCDRV-TN2L7-N6BFA-5FY74
