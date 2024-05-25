defmodule WhozonlineWeb.Presence do
  use Phoenix.Presence,
    otp_app: :presence_demo,
    pubsub_server: Whozonline.PubSub
end
