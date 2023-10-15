defmodule ShapeFinder.ShapesTest do
  use ShapeFinder.DataCase

  alias ShapeFinder.Shapes

  describe "shapes" do
    alias ShapeFinder.Shapes.Shape

    import ShapeFinder.ShapesFixtures

    @invalid_attrs %{color: "foobar", sides: 42, dimensions: "nope"}

    test "list_shapes/0 returns all shapes" do
      shape = shape_fixture()
      assert Shapes.list_shapes() == [shape]
    end

    test "get_shape!/1 returns the shape with given id" do
      shape = shape_fixture()
      assert Shapes.get_shape!(shape.id) == shape
    end

    test "create_shape/1 with valid data creates a shape" do
      valid_attrs = %{color: :blue, sides: 4, dimensions: :big}

      assert {:ok, %Shape{} = shape} = Shapes.create_shape(valid_attrs)
      assert shape.color == :blue
      assert shape.sides == 4
      assert shape.dimensions == :big
    end

    test "create_shape/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shapes.create_shape(@invalid_attrs)
    end

    test "update_shape/2 with valid data updates the shape" do
      shape = shape_fixture()
      update_attrs = %{color: :red, sides: 5, dimensions: :small}

      assert {:ok, %Shape{} = shape} = Shapes.update_shape(shape, update_attrs)
      assert shape.color == :red
      assert shape.sides == 5
      assert shape.dimensions == :small
    end

    test "update_shape/2 with invalid data returns error changeset" do
      shape = shape_fixture()
      assert {:error, %Ecto.Changeset{}} = Shapes.update_shape(shape, @invalid_attrs)
      assert shape == Shapes.get_shape!(shape.id)
    end

    test "delete_shape/1 deletes the shape" do
      shape = shape_fixture()
      assert {:ok, %Shape{}} = Shapes.delete_shape(shape)
      assert_raise Ecto.NoResultsError, fn -> Shapes.get_shape!(shape.id) end
    end

    test "change_shape/1 returns a shape changeset" do
      shape = shape_fixture()
      assert %Ecto.Changeset{} = Shapes.change_shape(shape)
    end
  end
end
