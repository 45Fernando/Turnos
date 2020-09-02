defmodule Turnos.AppointmentsTest do
  use Turnos.DataCase

  alias Turnos.Appointments

  describe "appointments" do
    alias Turnos.Appointments.Appointment

    @valid_attrs %{appointment_date: ~D[2010-04-17], availability: true, time_end: ~T[14:00:00], time_start: ~T[14:00:00]}
    @update_attrs %{appointment_date: ~D[2011-05-18], availability: false, time_end: ~T[15:01:01], time_start: ~T[15:01:01]}
    @invalid_attrs %{appointment_date: nil, availability: nil, time_end: nil, time_start: nil}

    def appointment_fixture(attrs \\ %{}) do
      {:ok, appointment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Appointments.create_appointment()

      appointment
    end

    test "list_appointments/0 returns all appointments" do
      appointment = appointment_fixture()
      assert Appointments.list_appointments() == [appointment]
    end

    test "get_appointment!/1 returns the appointment with given id" do
      appointment = appointment_fixture()
      assert Appointments.get_appointment!(appointment.id) == appointment
    end

    test "create_appointment/1 with valid data creates a appointment" do
      assert {:ok, %Appointment{} = appointment} = Appointments.create_appointment(@valid_attrs)
      assert appointment.appointment_date == ~D[2010-04-17]
      assert appointment.availability == true
      assert appointment.time_end == ~T[14:00:00]
      assert appointment.time_start == ~T[14:00:00]
    end

    test "create_appointment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Appointments.create_appointment(@invalid_attrs)
    end

    test "update_appointment/2 with valid data updates the appointment" do
      appointment = appointment_fixture()
      assert {:ok, %Appointment{} = appointment} = Appointments.update_appointment(appointment, @update_attrs)
      assert appointment.appointment_date == ~D[2011-05-18]
      assert appointment.availability == false
      assert appointment.time_end == ~T[15:01:01]
      assert appointment.time_start == ~T[15:01:01]
    end

    test "update_appointment/2 with invalid data returns error changeset" do
      appointment = appointment_fixture()
      assert {:error, %Ecto.Changeset{}} = Appointments.update_appointment(appointment, @invalid_attrs)
      assert appointment == Appointments.get_appointment!(appointment.id)
    end

    test "delete_appointment/1 deletes the appointment" do
      appointment = appointment_fixture()
      assert {:ok, %Appointment{}} = Appointments.delete_appointment(appointment)
      assert_raise Ecto.NoResultsError, fn -> Appointments.get_appointment!(appointment.id) end
    end

    test "change_appointment/1 returns a appointment changeset" do
      appointment = appointment_fixture()
      assert %Ecto.Changeset{} = Appointments.change_appointment(appointment)
    end
  end
end
