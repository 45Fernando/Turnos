defmodule TurnosWeb.Admin.OfficePerView do
  use TurnosWeb, :view
  alias TurnosWeb.Admin.OfficePerView

  def render("index.json", %{offices_per: offices_per}) do
    %{data: render_many(offices_per, OfficePerView, "office_per.json")}
  end

  def render("show.json", %{office_per: office_per}) do
    %{data:
      render_one(office_per, OfficePerView, "office_per.json")
    }

  end

  def render("office_per.json", %{office_per: office_per}) do
    %{id: office_per.id,
      name: office_per.name,
      address: office_per.address,
      status: office_per.status,
      phone: office_per.phone,
      lat: office_per.lat,
      long: office_per.long,
      user_id: office_per.user_id
    }
  end
end
