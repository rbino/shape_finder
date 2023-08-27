defmodule TudeeFinderWeb.TudeeLiveTest do
  use TudeeFinderWeb.ConnCase

  import Phoenix.LiveViewTest
  import TudeeFinder.TudeesFixtures

  @create_attrs %{color: :blue, sides: 42, dimensions: :big}
  @update_attrs %{color: :red, sides: 43, dimensions: :small}
  @invalid_attrs %{color: nil, sides: nil, dimensions: nil}

  defp create_tudee(_) do
    tudee = tudee_fixture()
    %{tudee: tudee}
  end

  describe "Index" do
    setup [:create_tudee]

    test "lists all tudees", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/tudees")

      assert html =~ "Listing Tudees"
    end

    test "saves new tudee", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tudees")

      assert index_live |> element("a", "New Tudee") |> render_click() =~
               "New Tudee"

      assert_patch(index_live, ~p"/tudees/new")

      assert index_live
             |> form("#tudee-form", tudee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tudee-form", tudee: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tudees")

      html = render(index_live)
      assert html =~ "Tudee created successfully"
    end

    test "updates tudee in listing", %{conn: conn, tudee: tudee} do
      {:ok, index_live, _html} = live(conn, ~p"/tudees")

      assert index_live |> element("#tudees-#{tudee.id} a", "Edit") |> render_click() =~
               "Edit Tudee"

      assert_patch(index_live, ~p"/tudees/#{tudee}/edit")

      assert index_live
             |> form("#tudee-form", tudee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tudee-form", tudee: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tudees")

      html = render(index_live)
      assert html =~ "Tudee updated successfully"
    end

    test "deletes tudee in listing", %{conn: conn, tudee: tudee} do
      {:ok, index_live, _html} = live(conn, ~p"/tudees")

      assert index_live |> element("#tudees-#{tudee.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tudees-#{tudee.id}")
    end
  end

  describe "Show" do
    setup [:create_tudee]

    test "displays tudee", %{conn: conn, tudee: tudee} do
      {:ok, _show_live, html} = live(conn, ~p"/tudees/#{tudee}")

      assert html =~ "Show Tudee"
    end

    test "updates tudee within modal", %{conn: conn, tudee: tudee} do
      {:ok, show_live, _html} = live(conn, ~p"/tudees/#{tudee}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tudee"

      assert_patch(show_live, ~p"/tudees/#{tudee}/show/edit")

      assert show_live
             |> form("#tudee-form", tudee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#tudee-form", tudee: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tudees/#{tudee}")

      html = render(show_live)
      assert html =~ "Tudee updated successfully"
    end
  end
end
