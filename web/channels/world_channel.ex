defmodule Elixirquest.WorldChannel do
  use Phoenix.Channel
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

  def handle_in("client:init-world", msg, socket) do
    Logger.debug "-> Received Init World"
    Logger.debug "player data: "
    Logger.debug "-> #{inspect msg}"
#    TODO:
#   getOrCreate game_server
#   getOrCreate map
#   if new_player check socket and add player to registry (https://medium.com/@naveennegi/domain-driven-design-in-elixir-4dc416ac0a36 using via)
#   else if !check_player_id end else load_player
#

    push socket, "client:wait", %{}
    {:noreply, socket}
  end


  def handle_in(tag, msg, socket) do
    Logger.debug"-> Received Msg: Channel -#{inspect tag}- MSG -#{inspect msg}-"
    {:noreply, socket}
  end

end
