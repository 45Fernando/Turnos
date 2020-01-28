# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Turnos.Repo.insert!(%Turnos.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Turnos.Repo
alias Turnos.Roles.Role
alias Turnos.Users.User

#Seed de Roles
Repo.delete_all(Role)

#Roles
Repo.insert!(%Role{
  roleName: "admin"
})

Repo.insert!(%Role{
  roleName: "profesional"
})

Repo.insert!(%Role{
  roleName: "paciente"
})

# Seed de Users
Repo.delete_all(User)

# Doctores
Repo.insert!(%User{
  lastname: "Perez",
  mobilePhoneNumber: "3875147852",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20205557771",
  address: "Parque Belgrano Manzana 7 687",
  professionalAddress: "Avenida Belgrano 478",
  dni: "20555777",
  status: true,
  birthDate: ~D[1980-07-22],
  profilePicture: "url",
  mail: "juanperez@gmail.com",
  provincialRegistration: "888",
  nationalRegistration: "5555",
  name: "Juan",
  phoneNumber: "3874283312",
  professionalPhoneNumber: "3874963852"
})

Repo.insert!(%User{
  lastname: "Gutierrez",
  mobilePhoneNumber: "3875852963",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20177778881",
  address: "Alberdi 759",
  professionalAddress: "Alvarado 478",
  dni: "17777888",
  status: true,
  birthDate: ~D[1981-08-12],
  profilePicture: "url",
  mail: "normagutierrez@gmail.com",
  provincialRegistration: "125",
  nationalRegistration: "7365",
  name: "Norma",
  phoneNumber: "3874283312",
  professionalPhoneNumber: "3874963852"
})

# Users
Repo.insert!(%User{
  lastname: "Orquera",
  mobilePhoneNumber: "3875444666",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20351068141",
  address: "Barrio Las Rosas Los Tulipanes 464",
  dni: "35106814",
  status: true,
  birthDate: ~D[1990-03-02],
  profilePicture: "url",
  mail: "fernandoexequielorquera@gmail.com",
  name: "Fernando",
  phoneNumber: "3874283312"
})

Repo.insert!(%User{
  lastname: "Benavidez",
  mobilePhoneNumber: "3875777888",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20351113331",
  address: "Por alla",
  dni: "35111333",
  status: true,
  birthDate: ~D[1990-02-27],
  profilePicture: "url",
  mail: "josebenavidez@gmail.com",
  name: "Jose",
  phoneNumber: "3874666999"
})

Repo.insert!(%User{
  lastname: "Cardozo",
  mobilePhoneNumber: "3875777888",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20328887771",
  address: "Por alla pero mas aca",
  dni: "32888777",
  status: true,
  birthDate: ~D[1990-03-08],
  profilePicture: "url",
  mail: "rodrigocardozo@gmail.com",
  name: "Rodrigo",
  phoneNumber: "3876111555"
})
