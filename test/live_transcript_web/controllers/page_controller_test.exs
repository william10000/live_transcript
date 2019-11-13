defmodule LiveTranscriptWeb.PageControllerTest do
  use LiveTranscriptWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "App"
  end
end
