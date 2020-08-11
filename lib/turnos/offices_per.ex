defmodule Turnos.OfficesPer do
  @moduledoc """
  The Offices context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.OfficesPer.OfficePer

  @doc """
  Returns the list of offices.

  ## Examples

      iex> list_offices()
      [%Office{}, ...]

  """
  def list_offices_per do
    Repo.all(OfficePer)
  end

  @doc """
  Gets a single office.

  Raises `Ecto.NoResultsError` if the Office does not exist.

  ## Examples

      iex> get_office!(123)
      %Office{}

      iex> get_office!(456)
      ** (Ecto.NoResultsError)

  """
  def get_office_per!(id) do
    Repo.get!(OfficePer, id)
  end


  @doc """
  Creates a office.

  ## Examples

      iex> create_office(%{field: value})
      {:ok, %Office{}}

      iex> create_office(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_office_per(attrs \\ %{}) do
    %OfficePer{}
    |> OfficePer.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Updates a office.

  ## Examples

      iex> update_office(office, %{field: new_value})
      {:ok, %Office{}}

      iex> update_office(office, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_office_per(%OfficePer{} = office_per, attrs) do
    office_per
    |> OfficePer.changeset(attrs)
    |> Repo.update()
  end



  @doc """
  Deletes a Office.

  ## Examples

      iex> delete_office(office)
      {:ok, %Office{}}

      iex> delete_office(office)
      {:error, %Ecto.Changeset{}}

  """
  def delete_office_per(%OfficePer{} = office_per) do
    Repo.delete(office_per)
  end



  @doc """
  Returns an `%Ecto.Changeset{}` for tracking office changes.

  ## Examples

      iex> change_office(office)
      %Ecto.Changeset{source: %Office{}}

  """
  def change_office_per(%OfficePer{} = office_per) do
    OfficePer.changeset(office_per, %{})
  end
end
