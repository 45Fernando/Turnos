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
    %{id: user.id,
      name: user.name,
      lastname: user.lastname,
      dni: user.dni,
      mail: user.mail,
      address: user.address,
      professionalAddress: user.professionalAddress,
      password_hash: user.password_hash,
      phoneNumber: user.phoneNumber,
      professionalPhoneNumber: user.professionalPhoneNumber,
      mobilePhoneNumber: user.mobilePhoneNumber,
      profilePicture: user.profilePicture,
      status: user.status,
      birthDate: user.birthDate,
      cuil: user.cuil,
      nationalRegistration: user.nationalRegistration,
      provincialRegistration: user.provincialRegistration}
  end

end
