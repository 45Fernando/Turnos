defmodule Turnos.GuardianTokens do
  @moduledoc """
  The Roles context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.GuardianTokens.GuardianToken

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Role{}, ...]

  """
  def list_tokens do
    Repo.all(GuardianToken)
    |> Repo.preload(:users)
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Role{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id), do: Repo.get!(GuardianToken, id)

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %GuardianToken{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token(attrs \\ %{}) do
    %GuardianToken{}
    |> GuardianToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token.

  ## Examples

      iex> update_token(token, %{field: new_value})
      {:ok, %GuardianToken{}}

      iex> update_token(token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token(%GuardianToken{} = token, attrs) do
    token
    |> GuardianToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Token.

  ## Examples

      iex> delete_token(token)
      {:ok, %GuardianToken{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%GuardianToken{} = token) do
    Repo.delete(token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{source: %GuardianToken{}}

  """
  def change_token(%GuardianToken{} = token) do
    GuardianToken.changeset(token, %{})
  end
end
