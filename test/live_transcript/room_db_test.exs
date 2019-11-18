defmodule LiveTranscript.RoomDBTest do
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
    test "trying to create a room without a string name key raises an error" do
      [
        fn -> RoomDB.create_room(:a) end,
        fn -> RoomDB.create_room(1) end
      ]
      |> Enum.each(&assert_raise FunctionClauseError, &1)
    end

    test "you can create a room that has a unique name", %{pid: pid} do
      assert {:ok, room = %{name: "test"}} = RoomDB.create_room("test", pid)
      assert is_reference(room.uuid)
    end

    test "trying to create a room with a name that is taken will result in an error", %{pid: pid} do
      assert {:ok, %{name: "test"}} = RoomDB.create_room("test", pid)
      assert {:error, :name_taken} = RoomDB.create_room("test", pid)
    end
  end

  describe "room_exists?/1" do
    test "with a fresh name is false", %{table: table} do
      refute RoomDB.room_exists?("test", table)
    end

    test "With a taken name is true", %{table: table, pid: pid} do
      refute RoomDB.room_exists?("test", table)
      {:ok, _} = RoomDB.create_room("test", pid)
      assert RoomDB.room_exists?("test", table)
    end
  end

  describe "get_room/1" do
    test "trying to get a room that doesn't exist is an error", %{table: table} do
      assert {:error, :not_found} == RoomDB.get_room("test", table)
    end

    test "trying to get a room that exists brings back the room", %{pid: pid, table: table} do
      {:ok, _} = RoomDB.create_room("test", pid)
      assert {:ok, %{name: name}} = RoomDB.get_room("test", table)
    end
  end
end
