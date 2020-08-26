defmodule TurnosWeb.ConfigView do
  use TurnosWeb, :view
  alias TurnosWeb.ConfigView

  def render("index.json", %{configs: configs}) do
    %{data: render_many(configs, ConfigView, "config.json")}
  end

  def render("show.json", %{config: config}) do
    %{data:
      render_one(config, ConfigView, "config.json")
    }

  end

  def render("config.json", %{config: config}) do
    %{
      id: config.id,
      user_id: config.user_id,
      day_id: config.day_id,
      office_per_id: config.office_per_id,
      office_id: config.office_id,
      minutes_interval: config.minutes_interval,
      time_start: config.time_start,
      time_end: config.time_end,
      overturn: config.overturn,
      quantity_persons_overturn: config.quantity_persons_overturn,
      quantity_persons_per_day: config.quantity_persons_per_day,
      generate_every_days: config.generate_every_days,
      generate_up_to: config.generate_up_to
    }
  end
end
