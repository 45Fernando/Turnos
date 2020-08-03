defmodule TurnosWeb.UserView do
  use TurnosWeb, :view
  #alias TurnosWeb.UserView

  @doc """
  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data:
      render_one(user, UserView, "user.json"),
      roles: render_many(user.roles, TurnosWeb.Admin.RoleView, "role.json"),
      country: render_one(user.countries, TurnosWeb.Admin.CountryView, "country.json"),
      province: render_one(user.provinces, TurnosWeb.Admin.ProvinceView, "province.json")
    }
  end

  def render("show_mi.json", %{user: user}) do
    %{data:
        render_one(user, UserView, "user.json"),
        medicalsinsurances: render_many(user.medicalsinsurances, TurnosWeb.MedicalInsuranceView, "medical_insurance.json")
  }
  end

  def render("show_specialties.json", %{user: user}) do
    %{data:
        render_one(user, UserView, "user.json"),
        specialties: render_many(user.specialties, TurnosWeb.SpecialtyView, "specialty.json")
  }
  end

  def render("show_offices.json", %{user: user}) do
    %{data:
        render_one(user, UserView, "user.json"),
        usersoffices: render_many(user.usersoffices, TurnosWeb.UsersOfficesView, "user_office.json")
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
      #password_hash: user.password_hash,
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
  """

  def render("mail.json", %{message: message}) do
    %{
        message: message
      }
  end

end