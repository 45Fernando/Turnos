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
alias Turnos.MedicalsInsurances.MedicalInsurance
alias Turnos.Offices.Office
alias Turnos.Days.Day
alias Turnos.UsersOffices.UserOffice
alias Turnos.Specialties.Specialty
alias Turnos.Countries.Country

#Insertando paises
Repo.delete_all(Country)

paises_data = [
  %Country{
    name: "Argentina",
    code: "AR"
  },
  %Country{
    name: "Belgica",
    code: "BE"
  },
  %Country{
    name: "Canada",
    code: "CA"
  },
  %Country{
    name: "Francia",
    code: "FR"
  }
]

Enum.each(paises_data, fn(data) ->
  Repo.insert!(data)
end)

#Seed de Roles
Repo.delete_all(Role)

#Roles
roles_data = [%Role{ roleName: "admin"}, %Role{ roleName: "profesional"}, %Role{ roleName: "paciente"}]

Enum.each(roles_data, fn(data) ->
  Repo.insert!(data)
end)

# Seed de Users
Repo.delete_all(User)

users_data = [%User{
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
  professionalPhoneNumber: "3874963852",
  countries_id: 1
},
 %User{
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
  professionalPhoneNumber: "3874963852",
  countries_id: 1
},
%User{
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
  phoneNumber: "3874283312",
  countries_id: 1
},
%User{
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
  phoneNumber: "3874666999",
  countries_id: 1
},
%User{
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
  phoneNumber: "3876111555",
  countries_id: 1
}]


Enum.each(users_data, fn(data) ->
  Repo.insert!(data)
end)


#Obras Sociales
obrassociales_data = [%MedicalInsurance{
  cuit: "20789456221",
  name: "OSUNSa",
  businessName: "Obra Social de la UNSa",
  status: true
},
%MedicalInsurance{
  cuit: "20741258391",
  name: "OSPE",
  businessName: "Obra Social de Petroleros",
  status: true
},
%MedicalInsurance{
  cuit: "20789123641",
  name: "Swiss Medical",
  businessName: "Swiss Medical",
  status: true
}]

Enum.each(obrassociales_data, fn(data) ->
  Repo.insert!(data)
end)

#Consultorios
consultorios_data = [
  %Office{
    name: "CEMID",
    address: "Santa Fe 97",
    status: true
  },
  %Office{
    name: "Por + Salud",
    address: "Santa Fe 270",
    status: true
  },
  %Office{
    name: "Mas Medicina Ambulatoria",
    address: "Buenos Aires 196",
    status: true
  }
]

Enum.each(consultorios_data, fn(data) ->
  Repo.insert!(data)
end)

#Dias
dias_data = [
  %Day{
    name: "Lunes"
  },
  %Day{
    name: "Martes"
  },
  %Day{
    name: "Miercoles"
  },
  %Day{
    name: "Jueves"
  },
  %Day{
    name: "Viernes"
  },
  %Day{
    name: "Sabado"
  },
  %Day{
    name: "Domingo"
  }
]

Enum.each(dias_data, fn(data) ->
  Repo.insert!(data)
end)

#Insertando especialidades
especialidades_data = [
  %Specialty{
    name: "Ginecologia"
  },
  %Specialty{
    name: "Dermatologia"
  },
  %Specialty{
    name: "Cardiologia"
  },
  %Specialty{
    name: "Oftalmologia"
  },
  %Specialty{
    name: "Pediatria"
  },
  %Specialty{
    name: "Infectologia"
  }
]

Enum.each(especialidades_data, fn(data) ->
  Repo.insert!(data)
end)

#Consiguiendo el changeset de un usuario
user = Repo.get_by(User, mail: "rodrigocardozo@gmail.com")

#Asociando roles
lista_roles = %{"role_ids" => ["1", "2", "3"]}

user
|> Turnos.Users.update_user_roles(lista_roles)

#Asociando especialidades
lista_especialidades = %{"specialty_ids" => ["1", "2", "3"]}

user
|> Turnos.Users.update_user_specialties(lista_especialidades)

#Asociando consultorios
lista_mi = %{"medicalinsurance_ids" => ["1", "2"]}

user
|> Turnos.Users.update_user_mi(lista_mi)

#Asociando oficinas
lista_usersoffices = [
    %{user_id: "5", office_id: "1", day_id: "1", timeFrom: "09:00:00", timeTo: "21:00:00"},
    %{user_id: "5", office_id: "1", day_id: "2", timeFrom: "09:00:00", timeTo: "21:00:00"},
    %{user_id: "5", office_id: "1", day_id: "3", timeFrom: "09:00:00", timeTo: "13:00:00"},
    %{user_id: "5", office_id: "2", day_id: "3", timeFrom: "17:00:00", timeTo: "21:00:00"},
    %{user_id: "5", office_id: "2", day_id: "4", timeFrom: "09:00:00", timeTo: "21:00:00"},
    %{user_id: "5", office_id: "2", day_id: "5", timeFrom: "09:00:00", timeTo: "21:00:00"},
    %{user_id: "5", office_id: "2", day_id: "6", timeFrom: "09:00:00", timeTo: "13:00:00"}
  ]

Enum.each(lista_usersoffices, fn(data) ->
    Turnos.Users.create_user_offices(data)
end)

#Consiguiendo el changeset de un consultorio
office = Repo.get_by(Office, id: 1)

#Asociando dias y horarios a un consultorio
lista_officesdays = [
  %{office_id: "1", day_id: "1", timeFrom: "09:00:00", timeTo: "21:00:00", open: true},
  %{office_id: "1", day_id: "2", timeFrom: "09:00:00", timeTo: "21:00:00", open: true},
  %{office_id: "1", day_id: "3", timeFrom: "09:00:00", timeTo: "13:00:00", open: true},
  %{office_id: "1", day_id: "3", timeFrom: "17:00:00", timeTo: "21:00:00", open: true},
  %{office_id: "1", day_id: "4", timeFrom: "09:00:00", timeTo: "21:00:00", open: true},
  %{office_id: "1", day_id: "5", timeFrom: "09:00:00", timeTo: "21:00:00", open: true},
  %{office_id: "1", day_id: "6", timeFrom: "09:00:00", timeTo: "13:00:00", open: true},
  %{office_id: "1", day_id: "7", timeFrom: "00:00:00", timeTo: "00:00:00", open: false},
  ]

Enum.each(lista_officesdays, fn(data) ->
    Turnos.Offices.create_offices_days(data)
end)
