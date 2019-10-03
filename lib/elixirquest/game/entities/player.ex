defmodule Elixirquest.Game.Player do
  @moduledoc """
  Player
  """

  defstruct [
    x: 0,
    y: 0,
    size: 0,
    orientation: :vertical,
    coordinates: %{}
  ]

  def trim(player) do
    #TODO: trim the item data
  end

end
