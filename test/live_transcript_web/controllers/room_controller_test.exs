defmodule LiveTranscriptWeb.RoomControllerTest do
  use LiveTranscriptWeb.ConnCase
  alias LiveTranscript.{Room, RoomDB}

  test "GET /rooms/new", %{conn: conn} do
    conn = get(conn, "/rooms/new")
    assert html_response(conn, 200) =~ "Create a Room"
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
      name = unique_name()
      conn = post(conn, "/rooms", %{name: name})
      assert redirected_to(conn, 302) =~ "/rooms/#{name}"
    end

    test "With a taken name", %{conn: conn} do
      name = unique_name()
      RoomDB.create_room(%Room{name: name})
      conn = post(conn, "/rooms", %{name: name})
      assert html_response(conn, 200) =~ "Name Taken!"
    end
  end

  defp unique_name do
    "#{:erlang.unique_integer()}"
  end
end
