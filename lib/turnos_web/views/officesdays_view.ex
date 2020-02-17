defmodule TurnosWeb.OfficesDaysView do
  use TurnosWeb, :view
  alias TurnosWeb.OfficesDaysView

  def render("index.json", %{officesdays: officesdays}) do
    %{data: render_many(officesdays, OfficesDaysView, "office_day.json")}
  end

  def render("show.json", %{officeday: officeday}) do
    %{data:
      render_one(officeday, OfficesDaysView, "office_day.json")
  }

  end

  def render("office_day.json", %{offices_days: officeday}) do
    %{id: officeday.id,
      day: render_one(officeday.days, TurnosWeb.DayView, "day.json"),
      timeFrom: officeday.timeFrom,
      timeTo: officeday.timeTo}
  end
end
