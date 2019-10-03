defmodule Elixirquest.Game.Monster do
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

  def trim(monster) do
    #TODO: trim the item data
  end

end
