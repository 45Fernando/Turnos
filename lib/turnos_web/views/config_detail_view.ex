defmodule TurnosWeb.ConfigDetailView do
  use TurnosWeb, :view
  alias TurnosWeb.ConfigDetailView

  def render("index.json", %{config_details: config_details}) do
    %{data: render_many(config_details, ConfigDetailView, "config_detail.json")}
  end

  def render("show.json", %{config_detail: config_detail}) do
    %{data:
        render_one(config_detail, ConfigDetailView, "config_detail.json"),
        day: render_one(config_detail.days, TurnosWeb.DayView, "day.json"),
        office_per: render_one(config_detail.offices_per, TurnosWeb.OfficePerView, "office_per.json"),
        office: render_one(config_detail.offices, TurnosWeb.OfficeView, "office.json")
      }
  end

  def render("config_detail.json", %{config_detail: config_detail}) do
    %{
      id: config_detail.id,
      minutes_interval: config_detail.minutes_interval,
      start_time: config_detail.start_time,
      end_time: config_detail.end_time,
      overturn: config_detail.overturn,
      quantity_persons_overturn: config_detail.quantity_persons_overturn,
      quantity_persons_per_day: config_detail.quantity_persons_per_day
    }
  end
end
