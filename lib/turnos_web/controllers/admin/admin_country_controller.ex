defmodule TurnosWeb.Admin.CountryController do
  use TurnosWeb, :controller
  use PhoenixSwagger

  alias Turnos.Countries
  alias Turnos.Countries.Country
  alias Turnos.Repo

  action_fallback TurnosWeb.FallbackController

  def swagger_definitions do
    %{
      Country:
        swagger_schema do
          title("Country")
          description("A country of the world")

          properties do
            id(:integer, "The ID of the country")
            code(:string, "The code of the country", required: true)
            name(:string, "The name of the country", required: true)
            inserted_at(:string, "When was the country initially inserted", format: "ISO-8601")
            updated_at(:string, "When was the country last updated", format: "ISO-8601")
          end

          example(%{
            code: "AR",
            name: "Argentina",
            inserted_at: "2017-03-21T14:00:00Z",
            updated_at: "2017-03-21T14:00:00Z"
          })
        end,
      Countries:
        swagger_schema do
          title("Countries")
          description("All countries of the world")
          type(:array)
          items(Schema.ref(:Country))
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

  swagger_path :index do
    get("api/admin/countries")
    summary("List all countries")
    description("List all countries")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Countries))
    response(400, "Client Error")
  end

  def index(conn, _params) do
    countries = Countries.list_countries()

    conn
    |> put_view(TurnosWeb.CountryView)
    |> render("index.json", countries: countries)
  end

  swagger_path :create do
    post("api/admin/countries/")
    summary("Add a new country")
    description("Record a new country")

    parameters do
      country(:body, Schema.ref(:Country), "Country to record", required: true)
    end

    response(201, "Ok", Schema.ref(:Country))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, country_params) do
    with {:ok, %Country{} = country} <- Countries.create_country(country_params) do
      country = country |> Repo.preload(:provinces)

      conn
      |> put_view(TurnosWeb.CountryView)
      |> put_status(:created)
      |> put_resp_header("location", Routes.admin_country_path(conn, :show, country))
      |> render("show.json", country: country)
    end
  end

  swagger_path :show do
    get("api/admin/countries/{id}")
    summary("Retrieve a country")
    description("Retrieve a country")

    parameters do
      id(:path, :integer, "The id of the country", required: true)
    end

    response(200, "Ok", Schema.ref(:Country))
    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}) do
    country = Countries.get_country!(id)

    conn
    |> put_view(TurnosWeb.CountryView)
    |> render("show.json", country: country)
  end

  def update(conn, country_params) do
    country = Countries.get_country!(country_params["id"])
    country_params = Map.delete(country_params, "id")

    with {:ok, %Country{} = country} <- Countries.update_country(country, country_params) do
      conn
      |> put_view(TurnosWeb.CountryView)
      |> render("show.json", country: country)
    end
  end

  def delete(conn, %{"id" => id}) do
    country = Countries.get_country!(id)

    with {:ok, %Country{}} <- Countries.delete_country(country) do
      send_resp(conn, :no_content, "")
    end
  end
end
