defmodule BallonWeb.PageController do
  use BallonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
