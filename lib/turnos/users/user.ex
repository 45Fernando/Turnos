defmodule Turnos.Users.User do
  use Ecto.Schema
  use Waffle.Ecto.Schema
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
    field :location, :string
    field :avatar, TurnosWeb.Uploaders.Avatar.Type

    many_to_many(:roles, Turnos.Roles.Role, join_through: "users_roles", on_replace: :delete)
    many_to_many(:medicalsinsurances, Turnos.MedicalsInsurances.MedicalInsurance, join_through: "users_medicalsinsurances", on_replace: :delete)
    many_to_many(:specialties, Turnos.Specialties.Specialty, join_through: "users_specialties", on_replace: :delete)
    has_many(:offices_per, Turnos.OfficesPer.OfficePer, foreign_key: :user_id)
    belongs_to(:countries, Turnos.Countries.Country, foreign_key: :countries_id)
    belongs_to(:provinces, Turnos.Provinces.Province, foreign_key: :province_id)
    has_many(:guardian_tokens, Turnos.GuardianTokens.GuardianToken, foreign_key: :sub)
    has_one(:config_header, Turnos.ConfigHeaders.ConfigHeader, foreign_key: :user_id)
    has_many(:appointments_patient, Turnos.Appointments.Appointment, foreign_key: :patient_id)
    has_many(:appointments_professional, Turnos.Appointments.Appointment, foreign_key: :professional_id)

    timestamps()
  end

  @lista_cast ~w(name lastname dni mail address professionalAddress
  phoneNumber professionalPhoneNumber mobilePhoneNumber profilePicture status birthDate cuil nationalRegistration
  provincialRegistration countries_id province_id location)a

  @lista_cast_paciente ~w(name lastname dni mail address
  phoneNumber mobilePhoneNumber profilePicture birthDate
  countries_id province_id location)a

  @lista_validate_require ~w(name lastname dni mail address professionalAddress
   phoneNumber professionalPhoneNumber mobilePhoneNumber profilePicture status birthDate cuil nationalRegistration
  provincialRegistration countries_id province_id location)a

  @lista_require_paciente ~w(name lastname dni mail
  mobilePhoneNumber countries_id province_id location)a

  @lista_create_cast ~w(name lastname mail password countries_id)a
  @lista_create_validate_require ~w(name lastname mail password)a

  @lista_change_password_cast ~w(password)a
  @lista_change_password_validate_require ~w(password)a


  def create_changeset(usuario, attrs) do
    usuario
    |> cast(attrs, @lista_create_cast)
    |> validate_required(@lista_create_validate_require)
    |> foreign_key_constraint(:countries_id)
    |> foreign_key_constraint(:province_id) #TODO controlar si la provincia que viene pertenece al pais que viene
    |> unique_email()
    |> validate_password()
    |> put_pass_hash()
  end

  def update_changeset(usuario, attrs) do
    usuario
    |> cast(attrs, @lista_cast)
    |> validate_required([])#@lista_validate_require
    |> cast_attachments(attrs, [:avatar])
    |> foreign_key_constraint(:countries_id)
    |> foreign_key_constraint(:province_id)
    |> unique_email()
    |> put_pass_hash()
  end

  def update_paciente_changeset(user, attrs) do
    user
    |> cast(attrs, @lista_cast_paciente)
    |> validate_required(@lista_require_paciente)
    |> foreign_key_constraint(:countries_id)
    |> foreign_key_constraint(:province_id)
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


  def load_specialties(attrs) do
    case attrs["specialty_ids"] || [] do
      [] -> []
      ids -> Repo.all from s in Turnos.Specialties.Specialty, where: s.id in ^ids
    end
  end

  # decode base64 string to binary
  defp sanitize_params(%{"avatar64" => avatar64} = params) do
    params
    |> Map.put("avatar", Base.decode64!(avatar64))
    |> Map.delete("avatar64")
  end

end
