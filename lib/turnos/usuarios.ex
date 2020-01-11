defmodule Turnos.Usuarios do
  @moduledoc """
  The Usuarios context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.Usuarios.Usuario

  @doc """
  Returns the list of usuarios.

  ## Examples

      iex> list_usuarios()
      [%Usuario{}, ...]

  """
  def list_usuarios do
    Repo.all(Usuario)
  end

  @doc """
  Gets a single usuario.

  Raises `Ecto.NoResultsError` if the Usuario does not exist.

  ## Examples

      iex> get_usuario!(123)
      %Usuario{}

      iex> get_usuario!(456)
      ** (Ecto.NoResultsError)

  """
  def get_usuario!(id), do: Repo.get!(Usuario, id)

  @doc """
  Creates a usuario.

  ## Examples

      iex> create_usuario(%{field: value})
      {:ok, %Usuario{}}

      iex> create_usuario(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_usuario(attrs \\ %{}) do
    %Usuario{}
    |> Usuario.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a usuario.

  ## Examples

      iex> update_usuario(usuario, %{field: new_value})
      {:ok, %Usuario{}}

      iex> update_usuario(usuario, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_usuario(%Usuario{} = usuario, attrs) do
    usuario
    |> Usuario.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Usuario.

  ## Examples

      iex> delete_usuario(usuario)
      {:ok, %Usuario{}}

      iex> delete_usuario(usuario)
      {:error, %Ecto.Changeset{}}

  """
  def delete_usuario(%Usuario{} = usuario) do
    Repo.delete(usuario)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking usuario changes.

  ## Examples

      iex> change_usuario(usuario)
      %Ecto.Changeset{source: %Usuario{}}

  """
  def change_usuario(%Usuario{} = usuario) do
    Usuario.changeset(usuario, %{})
  end
end
