defmodule Turnos.ConfigDetails do
  @moduledoc """
  The ConfigDetails context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.ConfigDetails.ConfigDetail

  @doc """
  Returns the list of config_details.

  ## Examples

      iex> list_config_details()
      [%ConfigDetail{}, ...]

  """
  def list_config_details do
    Repo.all(ConfigDetail)
  end

  def get_config_details_by_user(user_id) do
    user_id
    |> Turnos.ConfigHeaders.get_config_by_user()
    |> Ecto.assoc(:config_details)
    |> preload(:days)
    |> preload(:offices_per)
    |> preload(:offices)
  end

  @doc """
  Gets a single config_detail.

  Raises `Ecto.NoResultsError` if the Config detail does not exist.

  ## Examples

      iex> get_config_detail!(123)
      %ConfigDetail{}

      iex> get_config_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_config_detail!(id), do: Repo.get!(ConfigDetail, id)

  @doc """
  Creates a config_detail.

  ## Examples

      iex> create_config_detail(%{field: value})
      {:ok, %ConfigDetail{}}

      iex> create_config_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_config_detail(attrs \\ %{}) do
    %ConfigDetail{}
    |> ConfigDetail.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, config_detail} -> {:ok, config_detail
                                     |> Repo.preload(:days)
                                     |> Repo.preload(:offices_per)
                                     |> Repo.preload(:offices)
                                    }
      error -> error
    end
  end

  @doc """
  Updates a config_detail.

  ## Examples

      iex> update_config_detail(config_detail, %{field: new_value})
      {:ok, %ConfigDetail{}}

      iex> update_config_detail(config_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_config_detail(%ConfigDetail{} = config_detail, attrs) do
    config_detail
    |> ConfigDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ConfigDetail.

  ## Examples

      iex> delete_config_detail(config_detail)
      {:ok, %ConfigDetail{}}

      iex> delete_config_detail(config_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_config_detail(%ConfigDetail{} = config_detail) do
    Repo.delete(config_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking config_detail changes.

  ## Examples

      iex> change_config_detail(config_detail)
      %Ecto.Changeset{source: %ConfigDetail{}}

  """
  def change_config_detail(%ConfigDetail{} = config_detail) do
    ConfigDetail.changeset(config_detail, %{})
  end
end
