defmodule RedPackProductions.Mixfile do
  use Mix.Project

  def project do
    [
      app: :red_pack_productions,
      version: "2.0.0",
      elixir: "1.6.2",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RedPackProductions.Application, []},
      extra_applications: [:logger, :runtime_tools, :timex, :bamboo, :bamboo_smtp, :httpoison, :cached_contentful]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.3"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:countries, "~> 1.4"},
      {:timex, "~> 3.1"},
      {:bamboo, "~> 0.8"},
      {:bamboo_smtp, "~> 1.4.0"},
      {:earmark, "~> 1.2"},
      {:httpoison, "~> 1.0", override: true},
      {:poison, "~> 3.1"},
      {:quantum, ">= 2.2.1"},
      {:cached_contentful, git: "https://github.com/weareyipyip/elixir-cached-contentful.git", tag: "0.3.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    []
  end
end
