defmodule LiveTranscriptWeb.RoomController do
  use LiveTranscriptWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(_conn, _params) do
    raise "Not Implememented"
  end

  def create(_conn, _params) do
    raise "Not Implemented"
  end
end
