defmodule TurnosWeb.UsersOfficesView do
  use TurnosWeb, :view
  alias TurnosWeb.UsersOfficesView

  def render("index.json", %{usersoffices: usersoffices}) do
    %{data: render_many(usersoffices, UsersOfficesView, "user_office.json")}
  end

  def render("show.json", %{useroffice: useroffice}) do
    %{data:
      render_one(useroffice, UsersOfficesView, "user_office.json")
  }

  end

  def render("user_office.json", %{users_offices: useroffice}) do
    %{id: useroffice.id,
      office: render_one(useroffice.offices, TurnosWeb.OfficeView, "office.json"),
      day: render_one(useroffice.days, TurnosWeb.DayView, "day.json"),
      timeFrom: useroffice.timeFrom,
      timeTo: useroffice.timeTo}
  end
end
