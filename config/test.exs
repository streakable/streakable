use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :streakable, Streakable.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :streakable, Streakable.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "streakable_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :guardian, Guardian,
  issuer: "Streakable.#{Mix.env}",
  ttl: {30, :days},
  verity_issuer: true,
  serializer: Streakable.GuardianSerializer,
  secret_key: "rH8RxOuc7MBMyI3Zl8r4DOlmWNNBgARhbofZ6pfNJtsPfCs2nlWpwnJ+vUDv8ms1"

