defmodule MyWordleWeb.GameLiveTest do
  use MyWordleWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "game start" do
    test "game start", %{conn: conn} do
      assert {:ok, view, html} = live(conn, "/game")

      assert html =~ ~r/Game Start/
    end
  end
end
