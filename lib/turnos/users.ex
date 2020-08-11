defmodule Turnos.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.Users.User
  alias Turnos.UsersOffices.UserOffice

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
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:roles)
    |> Repo.preload(:countries)
    |> Repo.preload(:provinces)
  end

  def get_usermi!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:medicalsinsurances)
  end

  def get_userspecialties!(id) do
    Repo.get(User, id)
    |> Repo.preload(:specialties)
  end

  def get_useroffice_per!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:offices_per)
  end

  def get_userofid!(id) do
    Repo.get!(UserOffice, id)
  end

  #Buscar un usuario por mail
  def get_user_by_mail(mail) do
    Repo.get_by(User, mail: mail)
  end

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
    |> User.update_changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, user} -> {:ok, Repo.preload(user, :countries, force: true)}
      error -> error
    end
  end

  @doc """
  Como manejar el error en la funcion update, por si hay que cambiarlo mas adelante
  defp update_child(child, params) do
  updated_child =
    child
    |> Child.changeset(params)
    |> Repo.update!()
    |> Repo.preload(:parent, force: true)
  rescue
    error in Ecto.InvalidChangesetError -> {:error, error.changeset}
    error in RuntimeError -> {:error, error.message}
  end
  """

  def update_password(%User{} = user, attrs) do
    user
    |> User.update_changeset_password(attrs)
    |> Repo.update()
  end

  def update_user_mi(%User{} = user, attrs) do
    user
    |> User.update_changeset_mi(attrs)
    |> Repo.update()
  end

  def create_user_offices(attrs \\ %{}) do
    %UserOffice{}
    |> UserOffice.changeset(attrs)
    |> Repo.insert()
  end


  def update_user_offices(%UserOffice{} = useroffice, attrs) do
    useroffice
    |> UserOffice.changeset(attrs)
    |> Repo.update()
  end

  def update_user_specialties(%User{} = user, attrs) do
    user
    |> User.update_changeset_specialties(attrs)
    |> Repo.update()
  end

  def update_user_roles(%User{} = user, attrs) do
    user
    |> User.update_changeset_roles(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Usuario>

  ## Examples

      iex> delete_usuario(usuario)
      {:ok, %Usuario{}}

      iex> delete_usuario(usuario)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def delete_user_office(%UserOffice{} = useroffice) do
    Repo.delete(useroffice)
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
      {:ok, user}
    else
      _ ->
        # Help to mitigate timing attacks
        Argon2.no_user_verify
        {:error, :unauthorised}
    end
  end

end
