defmodule Turnos.Provinces do
  @moduledoc """
  The Provinces context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.Provinces.Province

  @doc """
  Returns the list of provinces.

  ## Examples

      iex> list_provinces()
      [%Province{}, ...]

  """
  def list_provinces do
    Repo.all(Province)
  end

  @doc """
  Gets a single province.

  Raises `Ecto.NoResultsError` if the Province does not exist.

  ## Examples

      iex> get_province!(123)
      %Province{}

      iex> get_province!(456)
      ** (Ecto.NoResultsError)

  """
  def get_province!(id) do
    Repo.get!(Province, id)
  end


  def provinces_by_country(country_id)do
    country_id
    |> Turnos.Countries.get_country!()
    |> Ecto.assoc(:provinces)
  end

  @doc """
  Creates a province.

  ## Examples

      iex> create_province(%{field: value})
      {:ok, %Province{}}

      iex> create_province(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_province(attrs \\ %{}) do
    %Province{}
    |> Province.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a province.

  ## Examples

      iex> update_province(province, %{field: new_value})
      {:ok, %Province{}}

      iex> update_province(province, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_province(%Province{} = province, attrs) do
    province
    |> Province.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Province.

  ## Examples

      iex> delete_province(province)
      {:ok, %Province{}}

      iex> delete_province(province)
      {:error, %Ecto.Changeset{}}

  """
  def delete_province(%Province{} = province) do
    Repo.delete(province)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking province changes.

  ## Examples

      iex> change_province(province)
      %Ecto.Changeset{source: %Province{}}

  """
  def change_province(%Province{} = province) do
    Province.changeset(province, %{})
  end
end
