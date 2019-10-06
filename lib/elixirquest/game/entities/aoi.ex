defmodule Elixirquest.Game.Aoi do
  @moduledoc """
  AOI (Area of interest) is an abstraction from the map that allow us to
  separate logically the entire map into small pieces to manage all the game event
  """
  alias Elixirquest.Game.{ZoneUpdate}
  require Logger

  defstruct [
    aoi_id: nil,
    x: nil,
    y: nil,
    width: nil,
    height: nil,
    entities: [],
    zone_update: %ZoneUpdate{},
    adjacent_aois: []
  ]

  def create(aoi_id, x, y, w, h) do
    Logger.debug "Create new AOI #{aoi_id}, for x #{x} y #{y} w #{w} h #{h}"

    Agent.start(fn -> %__MODULE__{aoi_id: aoi_id, x: x, y: y, width: w, height: h} end, name: ref(aoi_id))
  end

  def get_zone_update(aoi_id) do
    Agent.get(ref(aoi_id), fn state -> state.zone_update end)
  end

  def clear_zone_update(aoi_id) do
    Agent.cast(ref(aoi_id), fn state -> %{state | zone_update: %ZoneUpdate{}} end )
  end

  def add_entity(aoi_id, entity, _previous) do
    Agent.cast(ref(aoi_id), fn state -> %{state | entities: [entity | state.entities]} end )

    # TODO: add those functions to world server
    # if(entity.__struct__ == Elixirquest.Game.Player) GameServer.server.addToRoom(entity.socketID,'AOI'+this.id)
    # GameServer.handleAOItransition(entity,previous)
  end

  def delete_entity(aoi_id, entity) do
    # TODO: check if this works, if not, just check entity id
    Agent.cast(ref(aoi_id), fn state -> %{state | entities: Enum.filter(state.entities, fn x -> x == entity end )} end )

    # TODO: add those functions to world server
    # if(entity.__struct__ == Elixirquest.Game.Player) GameServer.server.leaveRoom(entity.socketID,'AOI'+this.id)
  end

  def list_adjacent_aois(aoi_id, num_horizontal_aois, total_aois) do
    saved_adjacents = Agent.get(ref(aoi_id), fn state -> state.adjacent_aois end)

    if(Enum.empty?(saved_adjacents)) do
      Logger.debug("first time updating aoi #{aoi_id}, calculating adjacents...")
      adjacents = calculate_adjacents(aoi_id, num_horizontal_aois, total_aois)
      Agent.cast(ref(aoi_id), fn state -> %{state | adjacent_aois: adjacents} end )
      adjacents
    else
      saved_adjacents
    end
  end

  # Generates global reference name for the AOI process
  defp ref(aoi_id), do: {:global, {:aoi, aoi_id}}

  # Calculates the adjacents aois
  defp calculate_adjacents(aoi_id, num_horizontal_aois, total_aois) do
    top_to_bottom = plus_bottom_top(aoi_id, num_horizontal_aois)
    at_right = at_right(top_to_bottom, aoi_id, num_horizontal_aois)
    at_left = at_left(top_to_bottom, aoi_id, num_horizontal_aois)
    Enum.filter(top_to_bottom ++ at_right ++ at_left, fn x -> x > 0 and x < total_aois end)
  end

  defp plus_bottom_top(current, num_horizontal_aois) do
    [current - num_horizontal_aois, current, current + num_horizontal_aois]
  end

  defp at_right(adjacents, current, num_horizontal_aois) do
    # if is not at right, add the right aois as adjacents
    if(rem(current, num_horizontal_aois) !== 0) do
      Enum.map(adjacents, fn x -> x + 1 end )
    else
      []
    end
  end

  defp at_left(adjacents, current, num_horizontal_aois) do
    # if is not at left, add the right aois as adjacents
    if(rem(current, num_horizontal_aois) !== 1) do
      Enum.map(adjacents, fn x -> x - 1 end )
    else
      []
    end
  end

end
