defmodule TurnosWeb.HelpersDateTime do
  # Devuelve el tiempo ahora en UTC, pero el time lo devuelve en T[00:00:00.000000]
  def get_utc_with_start_time(datetime, start_time, time_zone) do
    date = datetime |> DateTime.to_date()
    time = start_time

    {:ok, naive_date_time} = NaiveDateTime.new(date, time)

    DateTime.from_naive!(naive_date_time, time_zone) |> DateTime.shift_zone!("Etc/UTC")
  end
end
