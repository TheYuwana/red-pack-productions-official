defmodule RedPackProductions.Web.Context do

	import Ecto.{Changeset}, warn: false
	alias RedPackProductions.Web.Reservation

	# Reservation
	def create_reservation(attrs \\ %{}) do
		%Reservation{}
			|> Reservation.changeset(attrs)
	end

	def change_reservation(%Reservation{} = reservation) do
		Reservation.changeset(reservation, %{})
	end
end