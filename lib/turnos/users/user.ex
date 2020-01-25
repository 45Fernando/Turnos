defmodule Turnos.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :lastname, :string
    field :mobilePhoneNumber, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :cuil, :string
    field :address, :string
    field :professionalAddress, :string
    field :dni, :string
    field :status, :boolean, default: false
    field :birthDate, :date
    field :profilePicture, :string
    field :mail, :string
    field :nationalRegistration, :string
    field :provincialRegistration, :string
    field :name, :string
    field :phoneNumber, :string
    field :professionalPhoneNumber, :string

    timestamps()
  end

  @lista_cast ~w(name lastname dni mail address professionalAddress password
  phoneNumber professionalPhoneNumber mobilePhoneNumber profilePicture status birthDate cuil nationalRegistration
 provincialRegistration)a

 @lista_validate_require ~w(name lastname dni mail address professionalAddress password
   phoneNumber professionalPhoneNumber mobilephoneNumber profilePicture status birthDate cuil nationalRegistration
  provincialRegistration)a

  @lista_create_cast ~w(name lastname mail password)a
  @lista_create_validate_require ~w(name lastname mail password)a


  def create_changeset(usuario, attrs) do
    usuario
    |> cast(attrs, @lista_create_cast)
    |> validate_required(@lista_create_validate_require)
    |> unique_email()
    |> validate_password()
    |> put_pass_hash()
  end

  @doc false
  def changeset(usuario, attrs) do
    usuario
    |> cast(attrs, @lista_cast)
    |> validate_required(@lista_validate_require)
    |> unique_email()
    |> put_pass_hash()
  end

  # validando que el correo tenga el formato correcto, un tamaño maximo
  # y que sea unico en la base de datos
  defp unique_email(changeset) do
    changeset
    |> validate_format(
      :mail,
      ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}$/
    )
    |> validate_length(:mail, max: 255)
    |> unique_constraint(:mail)
  end

  # If you are using Bcrypt or Pbkdf2, change Argon2 to Bcrypt or Pbkdf2
  defp put_pass_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset) do
    changeset
  end

  defp validate_password(changeset) do
    validate_change(changeset, :password, fn (:password, password) ->
      case NotQwerty123.PasswordStrength.strong_password?(password) do
        {:ok, _} ->  []
        {:error, msg} -> [{:password, msg}]
      end
    end)
  end
end
