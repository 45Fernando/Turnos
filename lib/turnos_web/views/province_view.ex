defmodule TurnosWeb.Admin.ProvinceView do
  use TurnosWeb, :view
  alias TurnosWeb.Admin.ProvinceView

  def render("index.json", %{provinces: provinces}) do
    %{data: render_many(provinces, ProvinceView, "province.json")}
  end

  def render("show.json", %{province: province}) do
    %{data: render_one(province, ProvinceView, "province.json")}
  end

  def render("province.json", %{province: province}) do
    %{id: province.id,
      name: province.name,
      code: province.code}
  end
end
