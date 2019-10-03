defmodule Elixirquest.Game.Route do
  @moduledoc """
  Route struct, manages routes for moving entities
  """

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
