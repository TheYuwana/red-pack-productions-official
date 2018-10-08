defmodule RedPackProductionsWeb.Reservation do
 	use Ecto.Schema
 	import Ecto.Changeset

 	alias RedPackProductionsWeb.Reservation

	schema "reservation" do
		field :comments, :string
		field :date, :string
		field :email, :string
		field :name, :string
		field :package, :string
		field :phone, :string
		field :hours, {:array, :string}
	end

	def changeset(%Reservation{} = reservation, attrs) do
		reservation
		|> cast(attrs, [:comments, :date, :email, :name, :package, :phone, :hours])
		|> validate_format(:email, ~r/(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)/, message: "Not a valid email")
		|> validate_required(:email, message: "An email is required")
		|> validate_required(:phone, message: "A phone number is required")
		|> validate_required(:package, message: "Please select a package")
	end

end