defmodule Test.Route do
  defstruct [
    route_id: nil,
    path: [],
    departureTime: 0,
    delta: 0,
    action: 0,
    orientation: :down
  ]

  def trim_route(route, "player") do
    %{ orientation: route.orientation, end: List.last(route.path), delta: route.delta}
  end

  def trim_route(route, "monster") do
    %{ path: route.path, delta: route.delta}
  end
end

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

def update_route(zone_update, category, entityId, property, value) do
  to_update = get_right_update_from_category(category)

  entities_updated = case Map.get(Map.get(zone_update, to_update), entityId) do
    nil ->
      Map.put(Map.get(zone_update, to_update), entityId, %{property => value})
    entity ->
      Map.put(Map.get(zone_update, to_update), entityId, Map.put(entity, property, value))
  end

  Map.put(zone_update, to_update, entities_updated)
end

defp get_right_update_from_category(category) do
  case category do
    "monster" -> :monsters
    "player"  -> :players
    "item"    -> :items
  end
end

  #TODO: should create methods to manage updates
end

defmodule Main do
  def main do
    test_route = %Test.Route{route_id: "eo", path: ["asdf", "fdsa"], departureTime: 10, delta: 20, action: 30, orientation: :up}

    IO.inspect(test_route)

    IO.inspect(Test.Route.trim_route(test_route, "monster"))
    IO.inspect(Test.Route.trim_route(test_route, "player"))

    IO.puts("------------------")

    zone_update = %Elixirquest.Game.ZoneUpdate{}

    IO.inspect(zone_update)

    zone_updated = Elixirquest.Game.ZoneUpdate.update_propery(zone_update, "item", "22", "route", ["eoeo"])
    IO.inspect(zone_updated)
    zone_updated = Elixirquest.Game.ZoneUpdate.update_property(zone_update, "monster", "22", "route", ["eoeo"])
    IO.inspect(zone_updated)
    zone_updated = Elixirquest.Game.ZoneUpdate.update_property(zone_update, "player", "22", "route", ["eoeo"])
    IO.inspect(zone_updated)

  end
end

Main.main
