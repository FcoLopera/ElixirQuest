defmodule Elixirquest.WorldChannel do
  use Phoenix.Channel

  alias Elixirquest.Game.Supervisor, as: GameSupervisor
  alias Elixirquest.Game.World, as: World
  require Logger

  def join("world:common", message, socket) do
    Process.flag(:trap_exit, true)
    send(self(), {:after_join, message})

    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, _msg}, socket) do
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug "-> leave #{inspect reason}"
    :ok
  end

  def handle_in("client:init-world", %{"new" => is_new_player} = data, socket) do
    Logger.debug "-> Received Init World"
    Logger.debug "player data: "
    Logger.debug "-> #{inspect data}"

#   Checks if a world exists in the supervisor, if not create one and returns its pid
    worlds = GameSupervisor.current_worlds()
    world_pid = if Enum.empty?(worlds) do
      {:ok, pid } = GameSupervisor.init_world()
      pid
    else
      {_, pid, _, _ } = Enum.at(worlds, 0)
      pid
    end

    Logger.debug "Worlds -> #{inspect world_pid}"

    if is_new_player do
      Logger.debug "For the actual socket id #{inspect socket.assigns.socket_id}"
      Logger.debug "Socket_is_free:#{inspect World.is_socket_free(world_pid, socket.assigns.socket_id)}"
      Logger.debug "Add player to world...: #{inspect World.add_new_player(world_pid,data)}"

    else
      player_id = data["id"]
      Logger.debug "For the actual socket id of old player #{inspect socket.assigns.socket_id}"
      Logger.debug "With player_id: #{inspect player_id}"
      Logger.debug "Player_id_free:#{inspect "todo check player id from world"}"
    end

#    TODO:
#   getOrCreate map
#   if new_player check socket and add player to registry (https://medium.com/@naveennegi/domain-driven-design-in-elixir-4dc416ac0a36 using via)
#   else if !check_player_id end else load_player
#  More on Elixir quest start from here
#  - https://www.dynetisgames.com/2017/03/06/how-to-make-a-multiplayer-online-game-with-phaser-socket-io-and-node-js/

    push socket, "client:wait", %{}
    {:noreply, socket}
  end


  def handle_in(tag, msg, socket) do
    Logger.debug"-> Received Msg: Channel -#{inspect tag}- MSG -#{inspect msg}-"
    {:noreply, socket}
  end

end
