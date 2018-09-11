defmodule RedPackProductionsWeb.Context do

	import Ecto.{Changeset}, warn: false
	alias RedPackProductionsWeb.Reservation

	# Reservation
	def create_reservation(attrs \\ %{}) do
		%Reservation{}
			|> Reservation.changeset(attrs)
	end

	def change_reservation(%Reservation{} = reservation) do
		Reservation.changeset(reservation, %{})
	end
end