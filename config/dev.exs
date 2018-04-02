use Mix.Config

config :battlenet,
  redirect_uri: "https://localhost.test/auth/callback",
  region: "US"

import_config "dev.secret.exs"