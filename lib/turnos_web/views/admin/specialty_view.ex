defmodule TurnosWeb.Admin.SpecialtyView do
  use TurnosWeb, :view
  alias TurnosWeb.Admin.SpecialtyView

  def render("index.json", %{specialties: specialties}) do
    %{data: render_many(specialties, SpecialtyView, "specialty.json")}
  end

  def render("show.json", %{specialty: specialty}) do
    %{data: render_one(specialty, SpecialtyView, "specialty.json")}
  end

  def render("specialty.json", %{specialty: specialty}) do
    %{id: specialty.id,
      name: specialty.name}
  end
end
