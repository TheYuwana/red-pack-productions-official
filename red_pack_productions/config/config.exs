# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :red_pack_productions,
  ecto_repos: [],
  mollie_api_key: System.get_env("MOLLIE_API_KEY"),
  mollie_redirect_url: System.get_env("MOLLIE_REDIRECT_URL"),
  cf_cms_api_key: System.get_env("CF_CMS_API_KEY")

# Configures the endpoint
config :red_pack_productions, RedPackProductionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1Yoz85+s226nZkwcEdymcHiVzeS28cZsT4iKlYgaAcZZcRM1ZjP3aL/hjLPg3d/0",
  render_errors: [view: RedPackProductionsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RedPackProductions.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :cached_contentful,
	space_id: "6t670ovmra8o",
	access_token: "365c0c9b6dabf434bffdd06bcc662b526a33785cffeb5249697de4633bef1caf",
	default_language: "nl",
	auto_update: true,
	update_interval: 24 * 60 * 60 * 1000

config :red_pack_productions, RedPackProductions.Mailer,
  adapter: Bamboo.MandrillAdapter,
  api_key: System.get_env("MANDRILL_API_KEY")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
