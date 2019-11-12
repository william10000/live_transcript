defmodule LiveTranscriptWeb.PageController do
  use LiveTranscriptWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
