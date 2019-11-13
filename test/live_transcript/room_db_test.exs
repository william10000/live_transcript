defmodule LiveTranscript.RoomDBTest do
  alias LiveTranscript.Room
  alias LiveTranscript.RoomDB

  use ExUnit.Case

  setup do
    {:ok, pid} = RoomDB.start_link(unnamed: true)
    {:ok, %{pid: pid, table: RoomDB._get_table(pid)}}
  end

  test "You can start a RoomDB", %{pid: pid} do
    assert Process.alive?(pid)
  end

  describe "_get_table/0 && _get_table/1" do
    test "The name of the global table is the module name" do
      assert RoomDB == RoomDB._get_table()
    end

    test "You can get a reference to a Room DB ets table", %{pid: pid} do
      table = RoomDB._get_table(pid)
      assert is_reference(table)
    end
  end

  describe "create_room/1" do
    test "trying to create a room without a room struct + a string name key raises an error" do
      [
        fn -> RoomDB.create_room(%{}) end,
        fn -> RoomDB.create_room(%{name: "test"}) end,
        fn -> RoomDB.create_room(%Room{name: :a}) end,
        fn -> RoomDB.create_room(%Room{name: 1}) end
      ]
      |> Enum.each(&assert_raise FunctionClauseError, &1)
    end

    test "you can create a room that has a unique name", %{pid: pid, table: table} do
      room = %Room{name: "test"}
      assert {:ok, room} = RoomDB.create_room(room, pid)
    end

    test "trying to create a room with a name that is taken will result in an error", %{pid: pid} do
      room = %Room{name: "test"}
      assert {:ok, ^room} = RoomDB.create_room(room, pid)
      assert {:error, :name_taken} = RoomDB.create_room(room, pid)
    end
  end

  describe "room_exists?/1" do
    test "with a fresh name is false", %{table: table} do
      refute RoomDB.room_exists?("test", table)
    end

    test "With a taken name is true", %{table: table, pid: pid} do
      refute RoomDB.room_exists?("test", table)
      {:ok, _} = RoomDB.create_room(%Room{name: "test"}, pid)
      assert RoomDB.room_exists?("test", table)
    end
  end

  describe "get_room/1" do
    test "trying to get a room that doesn't exist is an error", %{table: table} do
      assert {:error, :not_found} == RoomDB.get_room("test", table)
    end

    test "trying to get a room that exists brings back the room", %{pid: pid, table: table} do
      room = %Room{name: "test"}
      {:ok, _} = RoomDB.create_room(room, pid)
      assert {:ok, ^room} = RoomDB.get_room("test", table)
    end
  end
end
