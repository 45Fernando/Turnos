defmodule Turnos.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Usuario{}, ...]

  """
  def list_users do
    Repo.all(User)
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
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:roles)

  @doc """
  Creates a usuario.

  ## Examples

      iex> create_usuario(%{field: value})
      {:ok, %Usuario{}}

      iex> create_usuario(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
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
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
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
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking usuario changes.

  ## Examples

      iex> change_usuario(usuario)
      %Ecto.Changeset{source: %Usuario{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end


  #Funcion para comparar el correo y la contraseña con la base de datos y autorizar el ingreso
  #O no.
  def login_email_password(nil, _password) do
    {:error, :invalid}
  end

  def login_email_password(_mail, nil) do
    {:error, :invalid}
  end

  def login_email_password(mail, password) do
    with  %User{} = user <- Repo.get_by(User, mail: mail) |> Repo.preload(:roles),
          true <- Argon2.verify_pass(password, user.password_hash) do
      IO.inspect(user, label: "Usuario")
      {:ok, user}
    else
      _ ->
        # Help to mitigate timing attacks
        Argon2.no_user_verify
        {:error, :unauthorised}
    end
  end

  #para agregar roles a un usuario
  def upsert_user_roles(user, role_ids) when is_list(role_ids) do
    roles =
      Role
      |> where([role], role.id in ^role_ids)
      |> Repo.all()

    with {:ok, _struct} <-
           user
           |> User.changeset_update_roles(roles)
           |> Repo.update() do
      {:ok, Turnos.Users.get_user!(user.id)}
    else
      error ->
        error
    end
  end


end
