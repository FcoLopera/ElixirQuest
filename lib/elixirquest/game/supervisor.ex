defmodule Elixirquest.Game.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Elixirquest.Game.Server, [], restart: :permanent)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  Creates a world or returns the current one supervised
  """
  def init_world() do
     Supervisor.start_child(__MODULE__, [])
  end

  @doc """
  Returns a list of the current games
  """
  def current_worlds do
    __MODULE__
    |> Supervisor.which_children
  end

end
