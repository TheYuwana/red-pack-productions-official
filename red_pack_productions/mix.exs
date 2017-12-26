defmodule RedPackProductions.Mixfile do
  use Mix.Project

  def project do
    [app: :red_pack_productions,
     version: "1.0.0",
     elixir: "1.5.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {RedPackProductions.Application, []},
     extra_applications: [:logger, :cached_contentful, :plug_ets_cache, :timex, :bamboo, :bamboo_smtp]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0", override: true},
     {:phoenix_pubsub, "~> 1.0.2"},
     {:phoenix_ecto, "~> 3.2"},
     {:phoenix_html, "~> 2.10.5"},
     {:phoenix_live_reload, "~> 1.1.3", only: :dev},
     {:gettext, "~> 0.13.1"},
     {:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.4.3", override: true},
     {:plug_ets_cache, "~> 0.1.0"},
     {:countries, "~> 1.4"},
     {:timex, "~> 3.1"},
     {:bamboo, "~> 0.8"},
     {:bamboo_smtp, "~> 1.4.0"},
     {:earmark, "~> 1.2"},
     {:cached_contentful, git: "https://github.com/weareyipyip/elixir-cached-contentful.git", tag: "0.2.0"}]
  end
end
