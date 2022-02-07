defmodule MyWordleWeb.PageController do
  use MyWordleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
