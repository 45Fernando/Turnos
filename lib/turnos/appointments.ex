defmodule Turnos.Appointments do
  @moduledoc """
  The Appointments context.
  """

  import Ecto.Query, warn: false
  alias Turnos.Repo

  alias Turnos.Appointments.Appointment

  @doc """
  Returns the list of appointments.

  ## Examples

      iex> list_appointments()
      [%Appointment{}, ...]

  """
  def list_appointments do
    Repo.all(Appointment)
  end

  @doc """
  Gets a single appointment.

  Raises `Ecto.NoResultsError` if the Appointment does not exist.

  ## Examples

      iex> get_appointment!(123)
      %Appointment{}

      iex> get_appointment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_appointment!(id), do: Repo.get!(Appointment, id)

  def get_appointments_by_users(user_id) do
    today = DateTime.now!("Etc/UTC")

    user_id
    |> Turnos.Users.get_user!()
    |> Ecto.assoc(:appointments_patient)
    |> where([a], a.appointment_date >= ^today)
    |> order_by(asc: :appointment_date)
  end

  def get_appointments_by_users(user_id, from_date, to_date) do
    user_id
    |> Turnos.Users.get_user!()
    |> Ecto.assoc(:appointments_patient)
    |> where([a], a.appointment_date >= ^from_date and a.appointment_date <= ^to_date)
  end

  def get_appointments_by_professional(user_id) do
    today = DateTime.now!("Etc/UTC")

    user_id
    |> Turnos.Users.get_user!()
    |> Ecto.assoc(:appointments_professional)
    |> where([a], a.appointment_date >= ^today)
    |> order_by(asc: :appointment_date)
  end

  def get_available_appointments_by_professional(user_id) do
    today = DateTime.now!("Etc/UTC")

    user_id
    |> Turnos.Users.get_user!()
    |> Ecto.assoc(:appointments_professional)
    |> where([a], a.appointment_date >= ^today)
    |> where([a], a.availability == true)
    |> order_by(asc: :appointment_date)
  end

  # Recupera el ultimo turno no disponible o devuelve nil si no encuentra nada
  def get_last_not_avalaible_appointment(user_id) do
    Repo.one(
      from a in Appointment,
        where: a.professional_id == ^user_id and a.availability == false,
        order_by: [desc: a.appointment_date],
        limit: 1
    )
  end

  # Recupera el ultimo turno  o devuelve nil si no encuentra nada
  def get_last_appointment(user_id) do
    Repo.one(
      from a in Appointment,
        where: a.professional_id == ^user_id,
        order_by: [desc: a.appointment_date],
        limit: 1
    )
  end

  @doc """
  Creates a appointment.

  ## Examples

      iex> create_appointment(%{field: value})
      {:ok, %Appointment{}}

      iex> create_appointment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_professional_appointment(attrs \\ %{}) do
    %Appointment{}
    |> Appointment.changeset_professional(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a appointment.

  ## Examples

      iex> update_appointment(appointment, %{field: new_value})
      {:ok, %Appointment{}}

      iex> update_appointment(appointment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_patient_appointment(%Appointment{} = appointment, attrs) do
    appointment
    |> Appointment.changeset_patient(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Appointment.

  ## Examples

      iex> delete_appointment(appointment)
      {:ok, %Appointment{}}

      iex> delete_appointment(appointment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_appointment(%Appointment{} = appointment) do
    Repo.delete(appointment)
  end

  # Borrar los turnos que sean mayor o igual a una fecha
  def delete_appointment_by_date(user_id, date) do
    from(a in Appointment, where: a.professional_id == ^user_id and a.appointment_date >= ^date)
    |> Repo.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking appointment changes.

  ## Examples

      iex> change_appointment(appointment)
      %Ecto.Changeset{source: %Appointment{}}

  """
  def change_appointment(%Appointment{} = appointment) do
    Appointment.changeset_patient(appointment, %{})
  end
end
