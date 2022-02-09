defmodule MyWordleWeb.PageControllerTest do
  use MyWordleWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
  end
end
