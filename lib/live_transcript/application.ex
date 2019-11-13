defmodule LiveTranscript.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      LiveTranscript.RoomDB,
      LiveTranscriptWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: LiveTranscript.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    LiveTranscriptWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
