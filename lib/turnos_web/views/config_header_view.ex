defmodule TurnosWeb.ConfigHeaderView do
  use TurnosWeb, :view
  alias TurnosWeb.ConfigHeaderView

  #def render("index.json", %{configs: configs}) do
  #  %{data: render_many(configs, ConfigHeaderView, "config.json")}
  #end

  def render("show.json", %{config_header: config_header}) do
    %{data:
      render_one(config_header, ConfigHeaderView, "config_header.json")
    }

  end

  def render("config_header.json", %{config_header: config_header}) do
    %{
      id: config_header.id,
      user_id: config_header.user_id,
      #day_id: config.day_id,
      #office_per_id: config.office_per_id,
      #office_id: config.office_id,
      #minutes_interval: config.minutes_interval,
      #time_start: config.time_start,
      #time_end: config.time_end,
      #overturn: config.overturn,
      #quantity_persons_overturn: config.quantity_persons_overturn,
      #quantity_persons_per_day: config.quantity_persons_per_day,
      generate_every_days: config_header.generate_every_days,
      generate_up_to: config_header.generate_up_to
    }
  end
end
