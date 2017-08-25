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

# Contentful
config :cached_contentful,
	space_id: "6t670ovmra8o",
	access_token: "365c0c9b6dabf434bffdd06bcc662b526a33785cffeb5249697de4633bef1caf",
	auto_update: true,
	update_interval: 24 * 60 * 60 *1000

# ETS Cache
config :plug_ets_cache,
  db_name: :rpp,
  ttl_check: 86400, # 24 hours
  ttl: 43200 # 12 hours

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# A3-QFGAJ8-DRL2P5-WCDRV-TN2L7-N6BFA-5FY74
