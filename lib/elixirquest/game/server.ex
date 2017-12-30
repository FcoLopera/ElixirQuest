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
    {:ok, map} = TiledMap.load_json_map(Path.join(:code.priv_dir(:elixirquest), "static/maps/minimap_server.json"))

    {:ok, db} = load_json("static/json/db.json") #Info about monsters, items, etc.
    {:ok, server_entities} = load_json("static/json/entities_server.json") # locations of monsters, objects, chests...
    {:ok, client_entities} = load_json("static/json/entities_client.json") # npc

    entities = Map.merge(server_entities, client_entities)
    items_id_map = Enum.map(db["items"], fn {key, properties} -> { properties["id"], key} end)

    IO.puts(inspect items_id_map)

    state=%{
      map: map, # object containing all the data about the world map
      mapReady: false, # is the server done processing the map or not
      # frequency of the server update loop ; rate at which the player and monsters objects will call their "update" methods
      # This is NOT the rate at which updates are sent to clients (see server.clientUpdateRate)
      updateRate: 1000/12,
      regenRate: 1000*2, # Rate at which the regenerate() method is called
      itemRespawnDelay: 1000*30, # Delay (ms) after which a respawnable item will respawn
      monsterRespawnDelay: 1000*30, # Delay (ms) after which a monster will respawn
      itemVanishDelay: 1000*9, # How long does dropped loot remain visible (ms)
      retryDelay: 1000*3, # Stuff don't respawn on cells occupied by players ; if a cell is occupied, the respawn call will retry after this amount of time (ms)
      walkUpdateDelay: 80, # How many ms between two updateWalk() calls
      fightUpdateDelay: 200, # How many ms between two updateFight() calls
      damageDelay: 1000, # How many ms before an entity can damage another one again
      positionCheckDelay: 1000, # How many ms before checkPosition() call
      lastItemID: 0, # ID of the last item object created
      lastMonsterID: 0,
      lastPlayerID: 0,
      AOIwidth: 34, # width in tiles of each AOI ; 6 AOIs horizontally in total
      AOIheight: 20, # height in tiles of each AOI ; 16 AOIs vertically in total
      nbConnectedChanged: false, # has the number of connected players changed since last update packet or not
      players: %{}, # map of all connected players, fetchable by id
      socketMap: %{}, # map of socket id's to the player id's of the associated players
      IDmap: %{}, # map of player id's to their mongo db uid's

      db: db,
      entities: entities,
      items_id_map: items_id_map
    }

    {:ok, state}
  end

  def handle_cast({:add_message, new_message}, messages) do
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end

  # helpers

  def load_json(static_path) do
    {:ok, body} = File.read(Path.join(:code.priv_dir(:elixirquest), static_path))
    Poison.decode(body)
  end


end
