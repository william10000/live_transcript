defmodule LiveTranscript.RoomDB do
  use GenServer
  alias LiveTranscript.Room

  def create_room(name, room_db \\ __MODULE__) when is_binary(name) do
    room = Room.new(name: name)
    GenServer.call(room_db, {:create_room, room})
  end

  def get_room(name, room_db \\ __MODULE__) do
    case :ets.lookup(room_db, name) do
      [{^name, room}] -> {:ok, room}
      _ -> {:error, :not_found}
    end
  end

  def room_exists?(name, room_db \\ __MODULE__) do
    :ets.member(room_db, name)
  end

  def init(opts) do
    ets_options =
      if(opts[:unnamed], do: [], else: [:named_table]) ++
        [:set, :protected, read_concurrency: true]

    table = :ets.new(__MODULE__, ets_options)
    {:ok, %{table: table}}
  end

  def start_link(opts) do
    genserver_options = if opts[:unnamed], do: [], else: [name: __MODULE__]
    GenServer.start_link(__MODULE__, opts, genserver_options)
  end

  def handle_call(:get_table, _from, state) do
    {:reply, state.table, state}
  end

  def handle_call({:create_room, room}, _from, state) do
    response =
      if :ets.insert_new(state.table, {room.name, room}) do
        {:ok, room}
      else
        {:error, :name_taken}
      end

    {:reply, response, state}
  end

  def _get_table(room_db \\ __MODULE__) do
    GenServer.call(room_db, :get_table)
  end
end
