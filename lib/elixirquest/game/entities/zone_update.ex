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
    players: [],      # Updates for properties of existing players
    items: [],        # Updates for properties of existing items
    monsters: []      # Updates for properties of existing monsters
  ]

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


#TODO: should create methods to manage updates


end
