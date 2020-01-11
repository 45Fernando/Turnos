defmodule Turnos.UsuariosTest do
  use Turnos.DataCase

  alias Turnos.Usuarios

  describe "usuarios" do
    alias Turnos.Usuarios.Usuario

    @valid_attrs %{apellido: "some apellido", celular: "some celular", contraseña: "some contraseña", cuil: "some cuil", direccion: "some direccion", direccionProfesional: "some direccionProfesional", dni: "some dni", estado: true, fechaNacimiento: ~D[2010-04-17], foto: "some foto", mail: "some mail", matricula: "some matricula", nombre: "some nombre", telefono: "some telefono", telefonoProfesional: "some telefonoProfesional"}
    @update_attrs %{apellido: "some updated apellido", celular: "some updated celular", contraseña: "some updated contraseña", cuil: "some updated cuil", direccion: "some updated direccion", direccionProfesional: "some updated direccionProfesional", dni: "some updated dni", estado: false, fechaNacimiento: ~D[2011-05-18], foto: "some updated foto", mail: "some updated mail", matricula: "some updated matricula", nombre: "some updated nombre", telefono: "some updated telefono", telefonoProfesional: "some updated telefonoProfesional"}
    @invalid_attrs %{apellido: nil, celular: nil, contraseña: nil, cuil: nil, direccion: nil, direccionProfesional: nil, dni: nil, estado: nil, fechaNacimiento: nil, foto: nil, mail: nil, matricula: nil, nombre: nil, telefono: nil, telefonoProfesional: nil}

    def usuario_fixture(attrs \\ %{}) do
      {:ok, usuario} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Usuarios.create_usuario()

      usuario
    end

    test "list_usuarios/0 returns all usuarios" do
      usuario = usuario_fixture()
      assert Usuarios.list_usuarios() == [usuario]
    end

    test "get_usuario!/1 returns the usuario with given id" do
      usuario = usuario_fixture()
      assert Usuarios.get_usuario!(usuario.id) == usuario
    end

    test "create_usuario/1 with valid data creates a usuario" do
      assert {:ok, %Usuario{} = usuario} = Usuarios.create_usuario(@valid_attrs)
      assert usuario.apellido == "some apellido"
      assert usuario.celular == "some celular"
      assert usuario.contraseña == "some contraseña"
      assert usuario.cuil == "some cuil"
      assert usuario.direccion == "some direccion"
      assert usuario.direccionProfesional == "some direccionProfesional"
      assert usuario.dni == "some dni"
      assert usuario.estado == true
      assert usuario.fechaNacimiento == ~D[2010-04-17]
      assert usuario.foto == "some foto"
      assert usuario.mail == "some mail"
      assert usuario.matricula == "some matricula"
      assert usuario.nombre == "some nombre"
      assert usuario.telefono == "some telefono"
      assert usuario.telefonoProfesional == "some telefonoProfesional"
    end

    test "create_usuario/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Usuarios.create_usuario(@invalid_attrs)
    end

    test "update_usuario/2 with valid data updates the usuario" do
      usuario = usuario_fixture()
      assert {:ok, %Usuario{} = usuario} = Usuarios.update_usuario(usuario, @update_attrs)
      assert usuario.apellido == "some updated apellido"
      assert usuario.celular == "some updated celular"
      assert usuario.contraseña == "some updated contraseña"
      assert usuario.cuil == "some updated cuil"
      assert usuario.direccion == "some updated direccion"
      assert usuario.direccionProfesional == "some updated direccionProfesional"
      assert usuario.dni == "some updated dni"
      assert usuario.estado == false
      assert usuario.fechaNacimiento == ~D[2011-05-18]
      assert usuario.foto == "some updated foto"
      assert usuario.mail == "some updated mail"
      assert usuario.matricula == "some updated matricula"
      assert usuario.nombre == "some updated nombre"
      assert usuario.telefono == "some updated telefono"
      assert usuario.telefonoProfesional == "some updated telefonoProfesional"
    end

    test "update_usuario/2 with invalid data returns error changeset" do
      usuario = usuario_fixture()
      assert {:error, %Ecto.Changeset{}} = Usuarios.update_usuario(usuario, @invalid_attrs)
      assert usuario == Usuarios.get_usuario!(usuario.id)
    end

    test "delete_usuario/1 deletes the usuario" do
      usuario = usuario_fixture()
      assert {:ok, %Usuario{}} = Usuarios.delete_usuario(usuario)
      assert_raise Ecto.NoResultsError, fn -> Usuarios.get_usuario!(usuario.id) end
    end

    test "change_usuario/1 returns a usuario changeset" do
      usuario = usuario_fixture()
      assert %Ecto.Changeset{} = Usuarios.change_usuario(usuario)
    end
  end
end
