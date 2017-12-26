defmodule RedPackProductions.Web.Context do

	import Ecto.{Changeset}, warn: false
	alias RedPackProductions.Web.Reservation


	# Reservation
	def create_reservation(attrs \\ %{}) do
		%Reservation{}
			|> reservation_changeset(attrs)
	end

	def change_reservation(%Reservation{} = reservation) do
		reservation_changeset(reservation, %{})
	end

	defp reservation_changeset(%Reservation{} = reservation, attrs) do
		reservation
			|> cast(attrs, [:comments, :date, :email, :name, :package, :phone])
			|> validate_format(:email, ~r/(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)/, message: "Not a valid email")
			|> validate_required(:email, message: "An email is required")
			|> validate_required(:phone, message: "A phone number is required")
			|> validate_required(:package, message: "Please select a package")
	end
end