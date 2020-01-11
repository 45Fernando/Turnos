defmodule TurnosWeb.UsuarioControllerTest do
  use TurnosWeb.ConnCase

  alias Turnos.Usuarios
  alias Turnos.Usuarios.Usuario

  @create_attrs %{
    apellido: "some apellido",
    celular: "some celular",
    contraseña: "some contraseña",
    cuil: "some cuil",
    direccion: "some direccion",
    direccionProfesional: "some direccionProfesional",
    dni: "some dni",
    estado: true,
    fechaNacimiento: ~D[2010-04-17],
    foto: "some foto",
    mail: "some mail",
    matricula: "some matricula",
    nombre: "some nombre",
    telefono: "some telefono",
    telefonoProfesional: "some telefonoProfesional"
  }
  @update_attrs %{
    apellido: "some updated apellido",
    celular: "some updated celular",
    contraseña: "some updated contraseña",
    cuil: "some updated cuil",
    direccion: "some updated direccion",
    direccionProfesional: "some updated direccionProfesional",
    dni: "some updated dni",
    estado: false,
    fechaNacimiento: ~D[2011-05-18],
    foto: "some updated foto",
    mail: "some updated mail",
    matricula: "some updated matricula",
    nombre: "some updated nombre",
    telefono: "some updated telefono",
    telefonoProfesional: "some updated telefonoProfesional"
  }
  @invalid_attrs %{apellido: nil, celular: nil, contraseña: nil, cuil: nil, direccion: nil, direccionProfesional: nil, dni: nil, estado: nil, fechaNacimiento: nil, foto: nil, mail: nil, matricula: nil, nombre: nil, telefono: nil, telefonoProfesional: nil}

  def fixture(:usuario) do
    {:ok, usuario} = Usuarios.create_usuario(@create_attrs)
    usuario
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all usuarios", %{conn: conn} do
      conn = get(conn, Routes.usuario_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create usuario" do
    test "renders usuario when data is valid", %{conn: conn} do
      conn = post(conn, Routes.usuario_path(conn, :create), usuario: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.usuario_path(conn, :show, id))

      assert %{
               "id" => id,
               "apellido" => "some apellido",
               "celular" => "some celular",
               "contraseña" => "some contraseña",
               "cuil" => "some cuil",
               "direccion" => "some direccion",
               "direccionProfesional" => "some direccionProfesional",
               "dni" => "some dni",
               "estado" => true,
               "fechaNacimiento" => "2010-04-17",
               "foto" => "some foto",
               "mail" => "some mail",
               "matricula" => "some matricula",
               "nombre" => "some nombre",
               "telefono" => "some telefono",
               "telefonoProfesional" => "some telefonoProfesional"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.usuario_path(conn, :create), usuario: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update usuario" do
    setup [:create_usuario]

    test "renders usuario when data is valid", %{conn: conn, usuario: %Usuario{id: id} = usuario} do
      conn = put(conn, Routes.usuario_path(conn, :update, usuario), usuario: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.usuario_path(conn, :show, id))

      assert %{
               "id" => id,
               "apellido" => "some updated apellido",
               "celular" => "some updated celular",
               "contraseña" => "some updated contraseña",
               "cuil" => "some updated cuil",
               "direccion" => "some updated direccion",
               "direccionProfesional" => "some updated direccionProfesional",
               "dni" => "some updated dni",
               "estado" => false,
               "fechaNacimiento" => "2011-05-18",
               "foto" => "some updated foto",
               "mail" => "some updated mail",
               "matricula" => "some updated matricula",
               "nombre" => "some updated nombre",
               "telefono" => "some updated telefono",
               "telefonoProfesional" => "some updated telefonoProfesional"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, usuario: usuario} do
      conn = put(conn, Routes.usuario_path(conn, :update, usuario), usuario: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete usuario" do
    setup [:create_usuario]

    test "deletes chosen usuario", %{conn: conn, usuario: usuario} do
      conn = delete(conn, Routes.usuario_path(conn, :delete, usuario))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.usuario_path(conn, :show, usuario))
      end
    end
  end

  defp create_usuario(_) do
    usuario = fixture(:usuario)
    {:ok, usuario: usuario}
  end
end
