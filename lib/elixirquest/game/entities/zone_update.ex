defmodule Elixirquest.Game.ZoneUpdate do
  @moduledoc """
   Each event should generate an update that is the result of those events.
   Those results are encapsulated in updates and should be sent to all interested clients
  """
  alias Elixirquest.Game.{Player}
  alias Elixirquest.Game.{Monster}
  alias Elixirquest.Game.{Item}

  defstruct [
    new_players: [],  # New players added to the world
    new_items: [],    # New items added to the world
    new_monsters: [], # New monsters added to the world
    disconnected: [], # Id`s of disconnected players since last updates
    # For the following updates we use maps containing each updated porperty
    # not defined structs for those entities
    players: %{},     # Updates for properties of existing players
    items: %{},       # Updates for properties of existing items
    monsters: %{}     # Updates for properties of existing monsters
  ]

  # Players and monsters updates has a property for route

def add_object(%{:new_players => new_players} = zone_update, %{category: "player"} = new_player_data) do
  updated_new_players = [Player.trim(new_player_data) | Enum.filter(new_players, fn(player) -> player.id !== new_player_data.id end)]
  %{zone_update | new_players: updated_new_players}
end

def add_object(%{:new_items => new_items} = zone_update, %{category: "item"} = new_item_data) do
  updated_new_items = [Item.trim(new_item_data) | Enum.filter(new_items, fn(item) -> item.id !== new_item_data.id end)]
  %{zone_update | new_items: updated_new_items}
end

def add_object(%{:new_monsters => new_monsters} = zone_update, %{category: "monster"} = new_monster_data) do
  updated_new_monsters = [Monster.trim(new_monster_data) | Enum.filter(new_monsters, fn(monster) -> monster.id !== new_monster_data.id end)]
  %{zone_update | new_monsters: updated_new_monsters}
end

def add_disconnect(zone_update, player_id) do
  %{zone_update | disconnected: [player_id | zone_update.disconnected]}
end

def update_propery(zone_update, category, entityId, property, value) do
  to_update = get_right_update_from_category(category)

  entities_updated = case Map.get(Map.get(zone_update, to_update), entityId) do
    nil ->
      Map.put(Map.get(zone_update, to_update), entityId, %{property => value})
    entity ->
      Map.put(Map.get(zone_update, to_update), entityId, Map.put(entity, property, value))
  end

  Map.put(zone_update, to_update, entities_updated)
end

def remove_echo(zone_update, player_id) do
  # The target player of an update package should not receive its own route info
  players_updated = case Map.get(zone_update.players, player_id) do
    nil    -> zone_update.players
    player ->
      case Map.delete(player, "route") do
        player_without_route when map_size(player_without_route) == 0 ->
          Map.delete(zone_update.players, player_id)
        player_without_route                                          ->
          Map.put(zone_update.players, player_id, player_without_route)
      end
  end

  # if the newplayer is the target player of the update packet, info is echo, removed
  new_players_filtered = Enum.filter(zone_update.new_players, fn player ->  player.id == player_id end)

  # Otherwise, check for redundancies between player and newplayer objects and remove them
  players_updated_not_new =
    List.foldl(new_players_filtered, players_updated, fn (player, acc) -> Map.delete(acc, player.id) end)

  %{zone_update | new_players: new_players_filtered, players: players_updated_not_new }
end

# Get updates about all entities present in the list of AOIs
def syncrhonize(zone_update, aoi) do
  # don't send the trimmed version, the trim is done in adObject()
  List.foldl(aoi.entities, zone_update, fn (entity, acc) -> Elixirquest.Game.ZoneUpdate.add_object(acc, entity) end)
end

def is_empty(%{:new_players => new_players} = _zone_update)   when length(new_players)  > 0, do: false
def is_empty(%{:new_monsters => new_monsters} = _zone_update) when length(new_monsters) > 0, do: false
def is_empty(%{:disconnected => disconnected} = _zone_update) when length(disconnected) > 0, do: false
def is_empty(%{:players => players} = _zone_update)           when map_size(players)    > 0, do: false
def is_empty(%{:items => items} = _zone_update)               when map_size(items)      > 0, do: false
def is_empty(%{:monsters => monsters} = _zone_update)         when map_size(monsters)   > 0, do: false
def is_empty(_zone_update), do: true

# Auxiliary functions
defp get_right_update_from_category(category) do
  case category do
    "monster" -> :monsters
    "player"  -> :players
    "item"    -> :items
  end
end

  #TODO: should create methods to manage updates
end
