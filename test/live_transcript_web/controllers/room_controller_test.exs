defmodule LiveTranscriptWeb.RoomControllerTest do
  use LiveTranscriptWeb.ConnCase

  test "GET /rooms/new", %{conn: conn} do
    conn = get(conn, "/rooms/new")
    assert html_response(conn, 200) =~ "App"
  end

  describe "GET /rooms/:id" do
    test "With a real room returns the room", %{conn: conn} do
      conn = get(conn, "/rooms/real")
      assert html_response(conn, 200) =~ "App"
    end

    test "With a fake room shows a not found", %{conn: conn} do
      conn = get(conn, "/rooms/fake")
      assert html_response(conn, 403) =~ "App"
    end
  end

  describe "POST /rooms" do
    test "With a unique name", %{conn: conn} do
      conn = post(conn, "/rooms", %{name: "unique"})
      assert redirected_to(conn, 302) =~ "/rooms/unique"
    end

    test "With a taken name", %{conn: conn} do
      conn = post(conn, "/rooms", %{name: "taken"})
      assert html_response(conn, 422) =~ "taken"
    end
  end
end
