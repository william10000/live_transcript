defmodule LiveTranscriptWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :live_transcript

  socket "/live", Phoenix.LiveView.Socket

  socket "/socket", LiveTranscriptWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :live_transcript,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_live_transcript_key",
    signing_salt: "tXNXY+5h"

  plug LiveTranscriptWeb.Router
end
