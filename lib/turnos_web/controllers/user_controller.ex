defmodule TurnosWeb.UserController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.Users
  alias Turnos.Users.User

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user")

          properties do
            id(:integer, "The ID of the user")
            lastname(:string, "The lastname of the user", required: true)
            mobilePhoneNumber(:string, "The mobile phone number of the user", required: true)
            cuil(:string, "The CUIL of the user", required: true)
            address(:string, "The address of the user", required: true)
            professionalAddress(:string, "The professional address of the user", required: true)
            dni(:string, "The DNI of the user", required: true)
            password(:string, "The password of the user", required: true)
            status(:boolean, "The status of the user", required: true)
            birthDate(:date, "The birthdate of the user", required: true)
            mail(:string, "The mail of the user", required: true)
            nationalRegistration(:string, "The national registration of the user", required: true)

            provincialRegistration(:string, "The provincial registration of the user",
              required: true
            )

            name(:string, "The name of the user", required: true)
            phoneNumber(:string, "The phone number of the user", required: true)

            professionalPhoneNumber(:string, "The professional phone number of the user",
              required: true
            )

            location(:string, "The location of the user", required: true)
            avatar(TurnosWeb.Uploaders.Avatar.Type, "The avatar of the user", required: false)
            roles(:array, "Has many roles")
            medicalsinsurances(:array, "Has many medicals insurances")
            specialties(:array, "Has many specialties")
            offices_per(:array, "Has many personalized offices")
            guardian_tokens(:array, "Has many Guardian tokens")
            config_header(:array, "Has one config header")
            appointments_patient(:array, "Has many appointments as a patient")
            appointments_professional(:array, "Has many appointments as a professional")

            inserted_at(:string, "When was the medical insurance initially inserted",
              format: "ISO-8601"
            )

            updated_at(:string, "When was the medical insurance last updated", format: "ISO-8601")
          end

          example(%{
            id: 1,
            lastname: "Gutierrez",
            mobilePhoneNumber: "3875852963",
            cuil: "20177778881",
            address: "Alberdi 759",
            professionalAddress: "Alvarado 478",
            dni: "17777888",
            status: true,
            birthDate: ~D[1981-08-12],
            mail: "normagutierrez@gmail.com",
            provincialRegistration: "125",
            nationalRegistration: "7365",
            name: "Norma",
            phoneNumber: "3874283312",
            professionalPhoneNumber: "3874963852",
            countries_id: 1,
            province_id: 2,
            location: "Salta"
          })
        end,
      Users:
        swagger_schema do
          title("Users")
          description("All users")
          type(:array)
          items(Schema.ref(:User))
        end,
      Error:
        swagger_schema do
          title("Errors")
          description("Error responses from the API")

          properties do
            error(:string, "The message of the error raised", required: true)
          end
        end
    }
  end

  def action(conn, _) do
    current_user_roles =
      conn |> Guardian.Plug.current_resource() |> TurnosWeb.ExtractRoles.extract_roles()

    apply(__MODULE__, action_name(conn), [conn, conn.params, current_user_roles])
  end

  swagger_path :index do
    get("/api/users")
    summary("List all users")
    description("List all users, will show acording to permisions")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Users))
    response(400, "Client Error")
  end

  def index(conn, _params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.index(conn, [])

      "patient" in current_user_roles ->
        TurnosWeb.Patient.UserController.index_professionals(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :create do
    post("/api/users/")
    summary("Add a new user")
    description("Record a new user")

    parameters do
      user(:body, Schema.ref(:User), "User to record", required: true)
    end

    response(201, "Ok", Schema.ref(:User))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, params, _current_user_roles) do
    TurnosWeb.Admin.UserController.create(conn, params)
  end

  swagger_path :show do
    get("/api/users/{id}")
    summary("Retrieve a user")
    description("Retrieve a user, will show data acording to permisions")

    parameters do
      id(:path, :integer, "The id of the user", required: true)
    end

    response(200, "Ok", Schema.ref(:User))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.show(conn, %{"id" => id})

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.show(conn, [])

      "patient" in current_user_roles ->
        TurnosWeb.Patient.UserController.show(conn, %{"id" => id})

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show_medicalsinsurances do
    get("/api/users/{user_id}/medicalsinsurances/")
    summary("Retrieve the medicals insurances of a user")
    description("Retrieve the medicals insurances of a user, will show acording to permisions")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(200, "Ok", Schema.ref(:MedicalsInsurances))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show_medicalsinsurances(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.show_medicalsinsurances(conn, id)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.show_medicalsinsurances(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show_specialties do
    get("/api/users/{user_id}/specialties/")
    summary("Retrieve the specialties of a user")
    description("Retrieve the specialties of a user, will show acording to permisions")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(200, "Ok", Schema.ref(:Specialties))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show_specialties(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.show_specialties(conn, id)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.show_specialties(conn, [])

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update do
    patch("/api/users/{id}")
    summary("Update the user ")
    description("Update the user, info to update is acording to permisions")

    parameters do
      user(:body, Schema.ref(:User), "User to record", required: true)

      id(:path, :integer, "The id of the user", required: true)
    end

    response(201, "Ok", Schema.ref(:User))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update(conn, params)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.update(conn, params)

      "patient" in current_user_roles ->
        TurnosWeb.Professional.UserController.update(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :search_by_mail do
    get("/api/users/search_by_mail/{mail}")
    summary("Search if a mail if being used ")
    description("Search if a mail if being used")

    parameters do
      mail(:path, :string, "The mail to search", required: true)
    end

    response(201, "Ok")
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def search_by_mail(conn, %{"mail" => mail}) do
    user = Users.get_user_by_mail(mail)

    message =
      if user != nil do
        "Not Available"
      else
        "Available"
      end

    conn
    |> put_view(TurnosWeb.UserView)
    |> render("mail.json", message: message)
  end

  swagger_path :update_password do
    patch("/api/users/{user_id}/updatepassword")
    summary("Update the user's password")
    description("Update the user's password")

    parameters do
      user(:body, Schema.ref(:User), "The password to update", required: true)

      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(201, "Ok", Schema.ref(:User))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update_password(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_password(conn, params)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.update_password(conn, params)

      "patient" in current_user_roles ->
        TurnosWeb.Patient.UserController.update_password(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update_medicalsinsurances do
    patch("/api/users/{user_id}/medicalsinsurances")
    summary("Update the user's medicals insurances")
    description("Update the user's medicals insurances, if permissions are good")

    parameters do
      medicalsinsurances(
        :body,
        Schema.ref(:MedicalsInsurances),
        "The users's medicals insurances to update",
        required: true
      )

      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(201, "Ok", Schema.ref(:MedicalsInsurances))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update_medicalsinsurances(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_medicalsinsurances(conn, params)

      "professional" in current_user_roles ->
        TurnosWeb.Professional.UserController.update_medicalsinsurances(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update_specialties do
    patch("/api/users/{user_id}/specialties")
    summary("Update the user's specialties")
    description("Update the user's specialties, if permissions are good")

    parameters do
      specialties(:body, Schema.ref(:Specialties), "The users's specialties to update",
        required: true
      )

      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(201, "Ok", Schema.ref(:Specialties))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update_specialties(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_specialties(conn, params)

      "professional" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_specialties(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :show_roles do
    get("/api/users/{user_id}/roles/")
    summary("Retrieve the roles of a user")
    description("Retrieve the roles of a user, will show acording to permisions")

    parameters do
      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(200, "Ok", Schema.ref(:Roles))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show_roles(conn, %{"id" => id}, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.show_roles(conn, id)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  swagger_path :update_roles do
    patch("/api/users/{user_id}/roles")
    summary("Update the user's roles")
    description("Update the user's roles, if permission are ok")

    parameters do
      roles(:body, Schema.ref(:Roles), "The users's roles to update", required: true)

      user_id(:path, :integer, "The id of the user", required: true)
    end

    response(201, "Ok", Schema.ref(:Roles))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update_roles(conn, params, current_user_roles) do
    cond do
      "admin" in current_user_roles ->
        TurnosWeb.Admin.UserController.update_roles(conn, params)

      true ->
        conn |> TurnosWeb.ExtractRoles.halt_connection()
    end
  end

  # No esta habilitado
  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
