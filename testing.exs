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

defmodule Main do
  def main do
    test_route = %Test.Route{route_id: "eo", path: ["asdf", "fdsa"], departureTime: 10, delta: 20, action: 30, orientation: :up}

    IO.inspect(test_route)

    IO.inspect(Test.Route.trim_route(test_route, "monster"))
    IO.inspect(Test.Route.trim_route(test_route, "player"))
  end
end

Main.main
