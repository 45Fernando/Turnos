defmodule TurnosWeb.UsuarioView do
  use TurnosWeb, :view
  alias TurnosWeb.UsuarioView

  def render("index.json", %{usuarios: usuarios}) do
    %{data: render_many(usuarios, UsuarioView, "usuario.json")}
  end

  def render("show.json", %{usuario: usuario}) do
    %{data: render_one(usuario, UsuarioView, "usuario.json")}
  end

  def render("usuario.json", %{usuario: usuario}) do
    %{id: usuario.id,
      nombre: usuario.nombre,
      apellido: usuario.apellido,
      dni: usuario.dni,
      mail: usuario.mail,
      direccion: usuario.direccion,
      direccionProfesional: usuario.direccionProfesional,
      password_hash: usuario.password_hash,
      telefono: usuario.telefono,
      telefonoProfesional: usuario.telefonoProfesional,
      celular: usuario.celular,
      foto: usuario.foto,
      estado: usuario.estado,
      fechaNacimiento: usuario.fechaNacimiento,
      cuil: usuario.cuil,
      matriculaNacional: usuario.matriculaNacional,
      matriculaProvincia: usuario.matriculaProvincial}
  end
end
