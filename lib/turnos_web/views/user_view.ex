defmodule TurnosWeb.UserView do
  use TurnosWeb, :view
  alias TurnosWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data:
      render_one(user, UserView, "user.json"),
      roles: render_many(user.roles, TurnosWeb.RoleView, "role.json"),
      country: render_one(user.countries, TurnosWeb.CountryView, "country.json"),
      province: render_one(user.provinces, TurnosWeb.ProvinceView, "province.json")
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
      profilePicture: user.profilePicture,
      status: user.status,
      birthDate: user.birthDate,
      cuil: user.cuil,
      nationalRegistration: user.nationalRegistration,
      provincialRegistration: user.provincialRegistration,
      location: user.location,
      avatars: TurnosWeb.Uploaders.Avatar.urls({user.avatar, user})
    }
  end

end
