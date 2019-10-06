defmodule Elixirquest.Game.PlayerUpdate do
  @moduledoc """
  Player
  """

  defstruct [
    life: nil,    # int
    x: nil,       # int
    y: nil,       # int
    no_pick: nil, # boolean
    hp: [],       # list of hp values to display as the result of fight actions between the player and enemies
    killed: [],   # list of id's of monsters killed since last update
    used: []      # list of id's of items used/picked since last update
  ]

  def is_empty(%{:hp => hp} = _player_update)           when length(hp)     > 0,     do: false
  def is_empty(%{:killed => killed} = _player_update)   when length(killed) > 0,     do: false
  def is_empty(%{:used => used} = _player_update)       when length(used)   > 0,     do: false
  def is_empty(%{:no_pick => no_pick} = _player_update) when no_pick        !== nil, do: false
  def is_empty(%{:x => x} = _player_update)             when x              !== nil, do: false
  def is_empty(%{:y => y} = _player_update)             when y              !== nil, do: false
  def is_empty(%{:life => life} = _player_update)       when life           !== nil, do: false
  def is_empty(_player_update), do: true

  # TODO: Are those updates really needed???
  def update_position(player_update, x, y) do
    %{player_update | x: x, y: y}
  end

  def update_life(player_update, life) do
    %{player_update | life: life}
  end

  def add_hp(player_update, target, hp, from) do
    # target (boolean) ; hp : int ; from : id (int)
    %{player_update | hp: [%{target: target, hp: hp, from: from } | player_update.hp ] }
  end

  def add_killed(player_update, killed_id) do
    %{player_update | killed: [killed_id | player_update.killed ]}
  end

  def add_used(player_update, used_id) do
    %{player_update | used: [used_id | player_update.used]}
  end

  def add_no_pick(player_update) do
    %{player_update | no_pick: true }
  end
  
end
