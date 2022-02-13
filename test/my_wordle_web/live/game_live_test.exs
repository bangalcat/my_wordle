defmodule MyWordleWeb.GameLiveTest do
  use MyWordleWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Mox

  setup :verify_on_exit!

  describe "game start" do
    setup :set_mox_global

    setup _ do
      MyWordle.Dictionary.Mock
      |> stub(:random_word, fn ->
        "WORDS"
      end)
      |> stub(:in_dictionary?, fn word ->
        true
      end)

      :ok
    end

    test "game start", %{conn: conn} do
      MyWordle.Dictionary.Mock
      |> expect(:random_word, 2, fn ->
        "WORDS"
      end)

      assert {:ok, view, html} = live(conn, "/game")

      assert html =~ ~r/Game Start/
    end

    test "make move", %{conn: conn} do
      MyWordle.Dictionary.Mock
      |> expect(:random_word, 2, fn ->
        "WORDS"
      end)
      |> expect(:in_dictionary?, 3, fn "WORDS" ->
        true
      end)

      assert {:ok, view, html} = live(conn, "/game")

      render_keydown(view, "make_move", %{"key" => "W"})
      render_keydown(view, "make_move", %{"key" => "O"})
      render_keydown(view, "make_move", %{"key" => "R"})
      render_keydown(view, "make_move", %{"key" => "D"})
      render_keydown(view, "make_move", %{"key" => "S"})
      render_keydown(view, "make_move", %{"key" => "Enter"})

      html = render(view)
      assert html =~ "Congratulation"
    end
  end
end
