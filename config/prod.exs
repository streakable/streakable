use Mix.Config

config :streakable, Streakable.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "streakable.herokuapp.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger, level: :info

config :streakable, Streakable.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :guardian, Guardian,
  issuer: "Streakable.#{Mix.env}",
  ttl: {30, :days},
  verity_issuer: true,
  serializer: Streakable.GuardianSerializer,
  secret_key: System.get_env("SECRET_KEY")

