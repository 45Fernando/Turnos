defmodule TurnosWeb.OfficeView do
  use TurnosWeb, :view
  alias TurnosWeb.OfficeView

  def render("index.json", %{offices: offices}) do
    %{data: render_many(offices, OfficeView, "office.json")}
  end

  def render("show.json", %{office: office}) do
    %{data: render_one(office, OfficeView, "office.json")}
  end

  def render("office.json", %{office: office}) do
    %{id: office.id,
      phone: office.phone,
      name: office.name,
      address: office.address,
      status: office.status,
      lat: office.lat,
      long: office.long}
  end
end
