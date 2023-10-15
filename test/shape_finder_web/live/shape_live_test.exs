defmodule ShapeFinderWeb.ShapeLiveTest do
  use ShapeFinderWeb.ConnCase

  import Phoenix.LiveViewTest
  import ShapeFinder.ShapesFixtures

  @create_attrs %{color: :blue, sides: 7, dimensions: :big}
  @update_attrs %{color: :red, sides: 8, dimensions: :small}
  @invalid_attrs %{color: nil, sides: nil, dimensions: nil}

  defp create_shape(_) do
    shape = shape_fixture()
    %{shape: shape}
  end

  describe "Index" do
    setup [:create_shape]

    test "lists all shapes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Shapes"
    end

    test "saves new shape", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("a", "New Shape") |> render_click() =~
               "New Shape"

      assert_patch(index_live, ~p"/new")

      assert index_live
             |> form("#shape-form", shape: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#shape-form", shape: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Shape created successfully"
    end

    test "updates shape in listing", %{conn: conn, shape: shape} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#shapes-#{shape.id}-edit") |> render_click() =~
               "Edit Shape"

      assert_patch(index_live, ~p"/#{shape}/edit")

      assert index_live
             |> form("#shape-form", shape: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#shape-form", shape: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Shape updated successfully"
    end

    test "deletes shape in listing", %{conn: conn, shape: shape} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#shapes-#{shape.id}-delete") |> render_click()
      refute has_element?(index_live, "#shapes-#{shape.id}")
    end
  end

  describe "Show" do
    setup [:create_shape]

    test "displays shape", %{conn: conn, shape: shape} do
      {:ok, _show_live, html} = live(conn, ~p"/#{shape}")

      assert html =~ "Show Shape"
    end

    test "updates shape within modal", %{conn: conn, shape: shape} do
      {:ok, show_live, _html} = live(conn, ~p"/#{shape}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Shape"

      assert_patch(show_live, ~p"/#{shape}/show/edit")

      assert show_live
             |> form("#shape-form", shape: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#shape-form", shape: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/#{shape}")

      html = render(show_live)
      assert html =~ "Shape updated successfully"
    end
  end
end
