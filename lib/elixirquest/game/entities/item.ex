defmodule Elixirquest.Game.Item do
  @moduledoc """
  Item
  """

  defstruct [
    x: 0,
    y: 0,
    size: 0,
    orientation: :vertical,
    coordinates: %{}
  ]


  def trim(item) do
    #TODO: trim the item data
  end
end
