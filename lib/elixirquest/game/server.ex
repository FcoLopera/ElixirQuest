defmodule Elixirquest.Game.Server do
  @moduledoc false
  use GenServer
  require Logger

  # API

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def add_message(pid, message) do
    GenServer.cast(pid, {:add_message, message})
  end

  def get_messages(pid) do
    GenServer.call(pid, :get_messages)
  end

  # SERVER

  def init(_) do
    map = get_map()
    state=initialize_state(map)
#    Logger.debug("#{inspect map}")
    {:ok, state}
  end

  def handle_cast({:add_message, new_message}, messages) do
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end

  # helpers

  def get_map()do
    with {:ok, body} <- File.read(Path.join(:code.priv_dir(:elixirquest), "static/maps/minimap_server.json")),
           {:ok, json} <- Poison.decode(body), do: json
  end

  def initialize_state(map) do
    state=%{
      objects: %{},
      layers: [],
      tilesets: %{}
    }

    Logger.debug("map --->>>> #{inspect map}")

    for layer <- map["layers"] do
      Logger.debug("layer --->>>> #{inspect layer}")
      case layer["type"] do
        "objectgroup" -> Logger.debug("object found #{layer["name"]}")
        "tilelayer" -> Logger.debug("object found #{layer["name"]}")
      end
    end

    state

  end

end
