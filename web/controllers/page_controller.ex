defmodule Elixirquest.PageController do
  use Elixirquest.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
