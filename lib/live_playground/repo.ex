defmodule LivePlayground.Repo do
  use Ecto.Repo,
    otp_app: :live_playground,
    adapter: Ecto.Adapters.Postgres
end
