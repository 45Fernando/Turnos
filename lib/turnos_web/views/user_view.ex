defmodule TurnosWeb.UserView do
  use TurnosWeb, :view
  alias TurnosWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      lastname: user.lastname,
      dni: user.dni,
      mail: user.mail,
      address: user.address,
      professionalAddress: user.professionalAddress,
      phoneNumber: user.phoneNumber,
      professionalPhoneNumber: user.professionalPhoneNumber,
      mobilePhoneNumber: user.mobilePhoneNumber,
      status: user.status,
      birthDate: user.birthDate,
      cuil: user.cuil,
      nationalRegistration: user.nationalRegistration,
      provincialRegistration: user.provincialRegistration,
      location: user.location,
      avatars: TurnosWeb.Uploaders.Avatar.urls({user.avatar, user}),
      roles: render_many(user.roles, TurnosWeb.RoleView, "role.json"),
      country: render_one(user.countries, TurnosWeb.CountryView, "country.json"),
      province: render_one(user.provinces, TurnosWeb.ProvinceView, "province.json")
    }
  end

  # Para mostrar el profesional desde el lado del paciente
  def render("index_professional.json", %{professionals: professionals}) do
    %{data: render_many(professionals, UserView, "professional.json", as: :professional)}
  end

  def render("show_professional.json", %{professional: professional}) do
    %{data: render_one(professional, UserView, "professional.json", as: :professional)}
  end

  def render("professional.json", %{professional: professional}) do
    %{
      id: professional.id,
      name: professional.name,
      lastname: professional.lastname,
      mail: professional.mail,
      professionalAddress: professional.professionalAddress,
      professionalPhoneNumber: professional.professionalPhoneNumber,
      status: professional.status,
      nationalRegistration: professional.nationalRegistration,
      provincialRegistration: professional.provincialRegistration,
      location: professional.location,
      avatars: TurnosWeb.Uploaders.Avatar.urls({professional.avatar, professional}),
      specialties: specialty?(professional.specialties),
      country: render_one(professional.countries, TurnosWeb.CountryView, "country.json"),
      province: render_one(professional.provinces, TurnosWeb.ProvinceView, "province.json")
    }
  end

  # mostrar el paciente desde el lado del profesional
  def render("index_patient.json", %{patients: patients}) do
    %{data: render_many(patients, UserView, "patient.json", as: :patient)}
  end

  def render("show_patient.json", %{patient: patient}) do
    %{data: render_one(patient, UserView, "patient.json", as: :patient)}
  end

  def render("patient.json", %{patient: patient}) do
    %{
      id: patient.id,
      name: patient.name,
      lastname: patient.lastname,
      dni: patient.dni,
      mail: patient.mail,
      address: patient.address,
      phoneNumber: patient.phoneNumber,
      mobilePhoneNumber: patient.mobilePhoneNumber,
      cuil: patient.cuil,
      location: patient.location,
      avatars: TurnosWeb.Uploaders.Avatar.urls({patient.avatar, patient}),
      country: render_one(patient.countries, TurnosWeb.CountryView, "country.json"),
      province: render_one(patient.provinces, TurnosWeb.ProvinceView, "province.json")
    }
  end

  def render("mail.json", %{message: message}) do
    %{
      message: message
    }
  end

  defp specialty?(specialty) do
    if Ecto.assoc_loaded?(specialty) do
      render_one(specialty, TurnosWeb.SpecialtyView, "specialty.json", as: :specialty)
    else
      []
    end
  end
end
