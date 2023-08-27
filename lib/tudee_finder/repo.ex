defmodule TudeeFinder.Repo do
  use Ecto.Repo,
    otp_app: :tudee_finder,
    adapter: Ecto.Adapters.Postgres
end
