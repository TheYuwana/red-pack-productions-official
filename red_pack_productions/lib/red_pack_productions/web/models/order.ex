defmodule RedPackProductionsWeb.Order do
 	use Ecto.Schema
 	import Ecto.Changeset

 	alias RedPackProductionsWeb.Order

	schema "order" do
		field :email, :string
		field :last_name, :string
		field :first_name, :string
		field :total_price, :float
	end

	def changeset(%Order{} = order, attrs) do
		order
		|> cast(attrs, [:email, :first_name, :last_name, :total_price])
		|> validate_format(:email, ~r/(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)/, message: "Not a valid email")
		|> validate_required(:email, message: "An email is required")
		|> validate_required(:first_name, message: "Please enter your first name")
		|> validate_required(:last_name, message: "Please enter your last name")
		|> validate_required(:total_price, message: "There is nothing in your basket!")
		|> validate_number(:total_price, greater_than: 0, message: "There is nothing in your basket!")
	end

end