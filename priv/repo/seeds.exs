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
alias Turnos.Usuarios.Usuario

# Seed de usuarios
Repo.delete_all(Usuario)

# Doctores
Repo.insert!(%Usuario{
  apellido: "Perez",
  celular: "3875147852",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20205557771",
  direccion: "Parque Belgrano Manzana 7 687",
  direccionProfesional: "Avenida Belgrano 478",
  dni: "20555777",
  estado: true,
  fechaNacimiento: ~D[1980-07-22],
  foto: "url",
  mail: "juanperez@gmail.com",
  matriculaProvincial: "888",
  matriculaNacional: "5555",
  nombre: "Juan",
  telefono: "3874283312",
  telefonoProfesional: "3874963852"
})

Repo.insert!(%Usuario{
  apellido: "Gutierrez",
  celular: "3875852963",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20177778881",
  direccion: "Alberdi 759",
  direccionProfesional: "Alvarado 478",
  dni: "17777888",
  estado: true,
  fechaNacimiento: ~D[1981-08-12],
  foto: "url",
  mail: "normagutierrez@gmail.com",
  matriculaProvincial: "125",
  matriculaNacional: "7365",
  nombre: "Norma",
  telefono: "3874283312",
  telefonoProfesional: "3874963852"
})

# Usuarios
Repo.insert!(%Usuario{
  apellido: "Orquera",
  celular: "3875444666",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20351068141",
  direccion: "Barrio Las Rosas Los Tulipanes 464",
  dni: "35106814",
  estado: true,
  fechaNacimiento: ~D[1990-03-02],
  foto: "url",
  mail: "fernandoexequielorquera@gmail.com",
  nombre: "Fernando",
  telefono: "3874283312"
})

Repo.insert!(%Usuario{
  apellido: "Benavidez",
  celular: "3875777888",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20351113331",
  direccion: "Por alla",
  dni: "35111333",
  estado: true,
  fechaNacimiento: ~D[1990-02-27],
  foto: "url",
  mail: "josebenavidez@gmail.com",
  nombre: "Jose",
  telefono: "3874666999"
})

Repo.insert!(%Usuario{
  apellido: "Cardozo",
  celular: "3875777888",
  password_hash: Argon2.add_hash("123456") |> Map.get(:password_hash),
  cuil: "20328887771",
  direccion: "Por alla pero mas aca",
  dni: "32888777",
  estado: true,
  fechaNacimiento: ~D[1990-03-08],
  foto: "url",
  mail: "rodrigocardozo@gmail.com",
  nombre: "Rodrigo",
  telefono: "3876111555"
})
