# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :drab_spike,
  ecto_repos: [DrabSpike.Repo]

# Configures the endpoint
config :drab_spike, DrabSpikeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "l/2Gm/HQgtPUjQSclNaCXZSuQiI4sQq8/2RWJE3bqRJD24948/5ZZmUT5VtP26HT",
  render_errors: [view: DrabSpikeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DrabSpike.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
