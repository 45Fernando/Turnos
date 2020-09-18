defmodule TurnosWeb.UserView do
  use TurnosWeb, :view
  alias TurnosWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data:
      render_one(user, UserView, "user.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
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

  #Para mostrar el profesional desde el lado del paciente
  def render("index_professional.json", %{professionals: professionals}) do
    %{data: render_many(professionals, UserView, "professional.json", as: :professional)}
  end

  def render("show_professional.json", %{professional: professional}) do
    %{data:
      render_one(professional, UserView, "professional.json", as: :professional)
    }
  end

  def render("professional.json", %{professional: professional}) do
    %{id: professional.id,
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
      roles: render_many(professional.roles, TurnosWeb.RoleView, "role.json"),
      country: render_one(professional.countries, TurnosWeb.CountryView, "country.json"),
      province: render_one(professional.provinces, TurnosWeb.ProvinceView, "province.json")
    }
  end

  def render("mail.json", %{message: message}) do
    %{
        message: message
      }
  end

end
