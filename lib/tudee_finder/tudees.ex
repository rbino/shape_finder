defmodule TudeeFinder.Tudees do
  @moduledoc """
  The Tudees context.
  """

  import Ecto.Query, warn: false
  alias TudeeFinder.Repo

  alias TudeeFinder.Tudees.Tudee

  @doc """
  Returns the list of tudees.

  ## Examples

      iex> list_tudees()
      [%Tudee{}, ...]

  """
  def list_tudees do
    Repo.all(Tudee)
  end

  @doc """
  Gets a single tudee.

  Raises `Ecto.NoResultsError` if the Tudee does not exist.

  ## Examples

      iex> get_tudee!(123)
      %Tudee{}

      iex> get_tudee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tudee!(id), do: Repo.get!(Tudee, id)

  @doc """
  Creates a tudee.

  ## Examples

      iex> create_tudee(%{field: value})
      {:ok, %Tudee{}}

      iex> create_tudee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tudee(attrs \\ %{}) do
    %Tudee{}
    |> Tudee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tudee.

  ## Examples

      iex> update_tudee(tudee, %{field: new_value})
      {:ok, %Tudee{}}

      iex> update_tudee(tudee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tudee(%Tudee{} = tudee, attrs) do
    tudee
    |> Tudee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tudee.

  ## Examples

      iex> delete_tudee(tudee)
      {:ok, %Tudee{}}

      iex> delete_tudee(tudee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tudee(%Tudee{} = tudee) do
    Repo.delete(tudee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tudee changes.

  ## Examples

      iex> change_tudee(tudee)
      %Ecto.Changeset{data: %Tudee{}}

  """
  def change_tudee(%Tudee{} = tudee, attrs \\ %{}) do
    Tudee.changeset(tudee, attrs)
  end
end
