defmodule TudeeFinder.TudeesTest do
  use TudeeFinder.DataCase

  alias TudeeFinder.Tudees

  describe "tudees" do
    alias TudeeFinder.Tudees.Tudee

    import TudeeFinder.TudeesFixtures

    @invalid_attrs %{color: "foobar", sides: 42, dimensions: "nope"}

    test "list_tudees/0 returns all tudees" do
      tudee = tudee_fixture()
      assert Tudees.list_tudees() == [tudee]
    end

    test "get_tudee!/1 returns the tudee with given id" do
      tudee = tudee_fixture()
      assert Tudees.get_tudee!(tudee.id) == tudee
    end

    test "create_tudee/1 with valid data creates a tudee" do
      valid_attrs = %{color: :blue, sides: 4, dimensions: :big}

      assert {:ok, %Tudee{} = tudee} = Tudees.create_tudee(valid_attrs)
      assert tudee.color == :blue
      assert tudee.sides == 4
      assert tudee.dimensions == :big
    end

    test "create_tudee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tudees.create_tudee(@invalid_attrs)
    end

    test "update_tudee/2 with valid data updates the tudee" do
      tudee = tudee_fixture()
      update_attrs = %{color: :red, sides: 5, dimensions: :small}

      assert {:ok, %Tudee{} = tudee} = Tudees.update_tudee(tudee, update_attrs)
      assert tudee.color == :red
      assert tudee.sides == 5
      assert tudee.dimensions == :small
    end

    test "update_tudee/2 with invalid data returns error changeset" do
      tudee = tudee_fixture()
      assert {:error, %Ecto.Changeset{}} = Tudees.update_tudee(tudee, @invalid_attrs)
      assert tudee == Tudees.get_tudee!(tudee.id)
    end

    test "delete_tudee/1 deletes the tudee" do
      tudee = tudee_fixture()
      assert {:ok, %Tudee{}} = Tudees.delete_tudee(tudee)
      assert_raise Ecto.NoResultsError, fn -> Tudees.get_tudee!(tudee.id) end
    end

    test "change_tudee/1 returns a tudee changeset" do
      tudee = tudee_fixture()
      assert %Ecto.Changeset{} = Tudees.change_tudee(tudee)
    end
  end
end
