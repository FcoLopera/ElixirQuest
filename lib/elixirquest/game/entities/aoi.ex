defmodule Elixirquest.Game.Aoi do
  @moduledoc """
  AOI (Area of interest) is an abstraction from the map that allow us to
  separate logically the entire map into small pieces to manage all the game event
  """

  defstruct [
    aoi_id: 0,
    x: 0,
    y: 0,
    width: 0,
    height: 0,
    entities: [],
    update_packet: nil
  ]


#TODO: should create aoi as agents to store status for each of the corresponding
# aoi in the game
end
