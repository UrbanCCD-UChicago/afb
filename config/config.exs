use Mix.Config

config :afb,
  ecto_repos: [Afb.Repo]

config :afb, AfbWeb.Endpoint,
  url: [
    host: "localhost"
  ],
  secret_key_base: "YvbBohZbq6f3gAuWKk5w+gMDs6o9aszwJVqlR/lydXYKA0BNGRrDd2HTrEDgzRuA",
  render_errors: [
    view: AfbWeb.ErrorView,
    accepts: ~w(html json)
  ],
  pubsub: [
    name: Afb.PubSub,
    adapter: Phoenix.PubSub.PG2
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id, :request_id],
  level: :info

config :afb, Afb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "password",
  database: "afb_#{Mix.env()}",
  hostname: "localhost",
  pool_size: 10

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, {:awscli, "default", 30}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, {:awscli, "default", 30}, :instance_role]

config :ex_aws, :hackney_opts,
  follow_redirect: true,
  recv_timeout: 30_000

config :ex_aws,
  region: "us-east-1"

config :afb, Afb.Scheduler,
  global: true,
  jobs: [
    {"*/5 * * * *", {Afb.Scheduler, :run, []}},
  ]

config :sentry, dsn: "https://public_key@app.getsentry.com/1",
  included_environments: [:prod],
  environment_name: Mix.env

import_config "#{Mix.env}.exs"
