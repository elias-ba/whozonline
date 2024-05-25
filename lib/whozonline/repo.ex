defmodule Whozonline.Repo do
  use Ecto.Repo,
    otp_app: :whozonline,
    adapter: Ecto.Adapters.Postgres
end
