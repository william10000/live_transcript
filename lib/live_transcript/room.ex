defmodule LiveTranscript.Room do
  @enforce_keys [:name, :uuid]
  defstruct [:name, :uuid]

  def new(name: name) do
    %__MODULE__{name: name, uuid: make_ref()}
  end
end
