defmodule Turnos.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Turnos.Repo

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

    many_to_many(:roles, Turnos.Roles.Role, join_through: "users_roles", on_replace: :delete)
    many_to_many(:medicalsinsurances, Turnos.MedicalsInsurances.MedicalInsurance, join_through: "users_medicalsinsurances", on_replace: :delete)
    many_to_many(:specialties, Turnos.Specialties.Specialty, join_through: "users_specialties", on_replace: :delete)
    has_many(:usersoffices, Turnos.UsersOffices.UserOffice, foreign_key: :user_id, on_replace: :raise)
    belongs_to(:countries, Turnos.Countries.Country)

    timestamps()
  end

  @lista_cast ~w(name lastname dni mail address professionalAddress
  phoneNumber professionalPhoneNumber mobilePhoneNumber profilePicture status birthDate cuil nationalRegistration
  provincialRegistration)a

  @lista_validate_require ~w(name lastname dni mail address professionalAddress
   phoneNumber professionalPhoneNumber mobilePhoneNumber profilePicture status birthDate cuil nationalRegistration
  provincialRegistration)a

  @lista_create_cast ~w(name lastname mail password countries_id)a
  @lista_create_validate_require ~w(name lastname mail password)a

  @lista_change_password_cast ~w(password)a
  @lista_change_password_validate_require ~w(password)a

  def create_changeset(usuario, attrs) do
    usuario
    |> cast(attrs, @lista_create_cast)
    |> validate_required(@lista_create_validate_require)
    |> foreign_key_constraint(attrs.countries_id)
    |> unique_email()
    |> validate_password()
    |> put_pass_hash()
  end

  def update_changeset(usuario, attrs) do
    usuario
    |> cast(attrs, @lista_cast)
    |> validate_required(@lista_validate_require)
    |> foreign_key_constraint(attrs.countries_id) #put_assoc(:country, attrs.countries_id)
    |> unique_email()
    |> put_pass_hash()
  end

  def update_changeset_password(usuario, attrs) do
    usuario
    |> cast(attrs, @lista_change_password_cast)
    |> validate_required(@lista_change_password_validate_require)
    |> unique_email()
    |> put_pass_hash()
  end

  def update_changeset_mi(usuario, attrs) do
    usuario
    |> Repo.preload(:medicalsinsurances)
    |> cast(attrs, [])
    |> cast_assoc(:medicalsinsurances, with: &Turnos.MedicalsInsurances.MedicalInsurance.changeset/2)
    |> put_assoc(:medicalsinsurances, load_medicalsinsurances(attrs))
  end

  def update_changeset_roles(usuario, attrs) do
    usuario
    |> Repo.preload(:roles)
    |> cast(attrs, [])
    |> cast_assoc(:roles, with: &Turnos.Roles.Role.changeset/2)
    |> put_assoc(:roles, load_roles(attrs))
  end

  def update_changeset_specialties(usuario, attrs) do
    usuario
    |> Repo.preload(:specialties)
    |> cast(attrs, [])
    |> cast_assoc(:specialties, with: &Turnos.Specialties.Specialty.changeset/2)
    |> put_assoc(:specialties, load_specialties(attrs))
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

  #Cargando los roles
  def load_roles(params) do
    case params["role_ids"] || [] do
      [] -> []
      ids -> Repo.all from r in Turnos.Roles.Role, where: r.id in ^ids
    end
  end

  def load_medicalsinsurances(params) do
    case params["medicalinsurance_ids"] || [] do
      [] -> []
      ids -> Repo.all from m in Turnos.MedicalsInsurances.MedicalInsurance, where: m.id in ^ids
    end
  end

  def load_offices(params) do
    case params["office_ids"] || [] do
      [] -> []
      ids -> Repo.all from o in Turnos.Offices.Office, where: o.id in ^ids
    end
  end

  def load_specialties(attrs) do
    case attrs["specialty_ids"] || [] do
      [] -> []
      ids -> Repo.all from s in Turnos.Specialties.Specialty, where: s.id in ^ids
    end
  end

end
