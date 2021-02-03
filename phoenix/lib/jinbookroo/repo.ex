defmodule Jinbookroo.Repo do
  use Ecto.Repo,
    otp_app: :jinbookroo,
    adapter: Ecto.Adapters.Postgres
end
