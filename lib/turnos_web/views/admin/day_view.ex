defmodule TurnosWeb.Admin.DayView do
  use TurnosWeb, :view
  alias TurnosWeb.Admin.DayView

  def render("index.json", %{days: days}) do
    %{data: render_many(days, DayView, "day.json")}
  end

  def render("show.json", %{day: day}) do
    %{data: render_one(day, DayView, "day.json")}
  end

  def render("day.json", %{day: day}) do
    %{id: day.id,
      name: day.name}
  end
end
