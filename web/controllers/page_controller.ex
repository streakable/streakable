defmodule Streakable.PageController do
  use Streakable.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
