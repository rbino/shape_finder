defmodule ShapeFinder.Repo do
  use Ecto.Repo,
    otp_app: :shape_finder,
    adapter: Ecto.Adapters.Postgres
end
