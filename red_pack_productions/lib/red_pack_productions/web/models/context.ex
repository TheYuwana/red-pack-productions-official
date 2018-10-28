defmodule RedPackProductionsWeb.Context do

	import Ecto.{Changeset}, warn: false
	alias RedPackProductionsWeb.Reservation
	alias RedPackProductionsWeb.Order

	# Reservation
	def create_reservation(attrs \\ %{}) do
		%Reservation{}
			|> Reservation.changeset(attrs)
	end

	def change_reservation(%Reservation{} = reservation) do
		Reservation.changeset(reservation, %{})
	end

	def create_order(attrs \\ %{}) do
		changeset = Order.changeset(%Order{}, attrs)
		if changeset.valid? do
			{:ok, :valid}
		else
			{:error, changeset}
		end
	end

	def change_order(%Order{} = order) do
		Order.changeset(order, %{})
	end
end