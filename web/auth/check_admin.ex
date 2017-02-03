defmodule Streakable.CheckAdmin do
  import Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.type == "admin" do
      conn
    else
      conn
      |> put_status(:not_found)
      |> render(Streakable.ErrorView, "404.html")
      |> halt
    end
  end
end
