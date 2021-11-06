defmodule Ballon.Repo do
  use Ecto.Repo,
    otp_app: :ballon,
    adapter: Ecto.Adapters.Postgres
end
