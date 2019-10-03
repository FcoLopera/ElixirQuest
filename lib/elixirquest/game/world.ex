defmodule Elixirquest.Game.World do
  @moduledoc false
  use GenServer
  require Logger

  # API

  def start_link do
    GenServer.start_link(__MODULE__, [])
    #  GenServer.start_link(__MODULE__, id, name: ref(id))
  end

  def is_socket_free(pid, socket_id) do
     GenServer.call(pid, {:is_socket_free, socket_id})
  end

  def add_new_player(pid, player_data) do
    IO.puts(player_data)
  end

  # Example function for api
  def add_message(pid, message) do
    GenServer.cast(pid, {:add_message, message})
  end

  def get_messages(pid) do
    GenServer.call(pid, :get_messages)
  end

  # SERVER
  @impl true
  def init(_) do
    #{:ok, map} = TiledMap.load_json_map(Path.join(:code.priv_dir(:elixirquest), "static/maps/minimap_server.json"))
    {:ok, map} = load_json("static/maps/minimap_server.json")
    {:ok, db} = load_json("static/json/db.json") #Info about monsters, items, etc.
    {:ok, server_entities} = load_json("static/json/entities_server.json") # locations of monsters, objects, chests...
    {:ok, client_entities} = load_json("static/json/entities_client.json") # npc

    entities = Map.merge(server_entities, client_entities)
    items_id_map = Enum.map(db["items"], fn {key, properties} -> { properties["id"], key} end)

    #%{"layers" => layers} = map

    Logger.debug(inspect Enum.count(map["layers"]))

    state=%{
      map: map, # object containing all the data about the world map
      map_ready: false, # is the server done processing the map or not
      # frequency of the server update loop ; rate at which the player and monsters objects will call their "update" methods
      # This is NOT the rate at which updates are sent to clients (see server.clientUpdateRate)
      update_rate: 1000/12,
      regen_rate: 1000*2, # Rate at which the regenerate() method is called
      item_respawn_delay: 1000*30, # Delay (ms) after which a respawnable item will respawn
      monster_respawn_delay: 1000*30, # Delay (ms) after which a monster will respawn
      item_vanish_delay: 1000*9, # How long does dropped loot remain visible (ms)
      retry_delay: 1000*3, # Stuff don't respawn on cells occupied by players ; if a cell is occupied, the respawn call will retry after this amount of time (ms)
      walk_update_delay: 80, # How many ms between two updateWalk() calls
      fight_update_delay: 200, # How many ms between two updateFight() calls
      damage_delay: 1000, # How many ms before an entity can damage another one again
      position_check_delay: 1000, # How many ms before checkPosition() call
      last_item_id: 0, # ID of the last item object created
      last_monster_id: 0,
      last_player_id: 0,
      aoi_width: 34, # width in tiles of each AOI ; 6 AOIs horizontally in total
      aoi_height: 20, # height in tiles of each AOI ; 16 AOIs vertically in total
      nb_connected_changed: false, # has the number of connected players changed since last update packet or not
      players: %{}, # map of all connected players, fetchable by id
      socket_map: %{}, # map of socket id's to the player id's of the associated players
      id_map: %{}, # map of player id's to their db uid's

      db: db,
      entities: entities,
      items_id_map: items_id_map
    }

    Logger.debug("World Genserver starts...")

    {:ok, state}
  end

  # Example function implementation
  @impl true
  def handle_cast({:add_message, new_message}, status) do
    {:noreply, [new_message | status]}
  end

  # Checks if a socket id is free to use (deal wiht collisions later)
  def handle_call({:is_socket_free, socket_id}, _from, %{:socket_map => socket_map} = status) do
    {:reply, socket_map[socket_id] == nil, status}
  end

  @impl true
  def handle_call(:get_messages, _from, status) do
    {:reply, status, status}
  end

  # helpers
  def load_json(static_path) do
    {:ok, body} = File.read(Path.join(:code.priv_dir(:elixirquest), static_path))
    Poison.decode(body)
  end

end
