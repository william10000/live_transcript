defmodule LiveTranscriptWeb.RoomController do
  use LiveTranscriptWeb, :controller
  alias LiveTranscript.{Room, RoomDB}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(_conn, _params) do
    raise "Not Implememented"
  end

  def create(conn, %{"name" => name}) do
    case RoomDB.create_room(%Room{name: name}, get_room_db()) do
      {:ok, room} ->
        redirect(conn, to: Routes.room_path(conn, :show, room.name))

      {:error, :name_taken} ->
        conn
        |> put_flash(:error, "Name Taken!")
        |> redirect(to: Routes.room_path(conn, :new))
    end
  end

  defp get_room_db do
    Process.get(:room_db) || RoomDB
  end
end
