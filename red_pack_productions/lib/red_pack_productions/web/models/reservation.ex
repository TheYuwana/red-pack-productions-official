defmodule RedPackProductions.Web.Reservation do
  use Ecto.Schema

  schema "reservation" do
    field :address, :string
    field :address_number, :string
    field :city, :string
    field :comments, :string
    field :country, :string
    field :date, :string
    field :email, :string
    field :firstname, :string
    field :lastname, :string
    field :package, :string
    field :phone, :string
    field :postcode, :string
  end

end