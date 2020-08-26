defmodule TurnosWeb.Admin.CountryController do
  use TurnosWeb, :controller

  alias Turnos.Countries
  alias Turnos.Countries.Country

  action_fallback TurnosWeb.FallbackController

  def index(conn, _params) do
    countries = Countries.list_countries()

    conn
    |> put_view(TurnosWeb.CountryView)
    |> render("index.json", countries: countries)
  end

  def create(conn, country_params) do
    with {:ok, %Country{} = country} <- Countries.create_country(country_params) do
      conn
      |> put_view(TurnosWeb.CountryView)
      |> put_status(:created)
      |> put_resp_header("location", Routes.admin_country_path(conn, :show, country))
      |> render("show.json", country: country)
    end
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
