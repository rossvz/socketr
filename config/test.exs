import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :socketr, SocketrWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6XZa+FVAkE+m+e71kwdgY9p+SKZ4qHRsUke4/wls7Zm3d/s2ZmmoKQAyZMHGmKa2",
  server: false

# In test we don't send emails.
config :socketr, Socketr.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
