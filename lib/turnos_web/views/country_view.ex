defmodule TurnosWeb.CountryView do
  use TurnosWeb, :view
  alias TurnosWeb.CountryView

  def render("index.json", %{countries: countries}) do
    %{data: render_many(countries, CountryView, "country.json")}
  end

  def render("show.json", %{country: country}) do
    %{
      data: render_one(country, CountryView, "country.json"),
      provinces: render_many(country.provinces, TurnosWeb.ProvinceView, "province.json")
    }
  end

  def render("country.json", %{country: country}) do
    %{id: country.id,
      name: country.name,
      code: country.code}
  end
end
