defmodule RedPackProductions.Web.Reservation do
  use Ecto.Schema

  schema "reservation" do
    field :comments, :string
    field :date, :string
    field :email, :string
    field :name, :string
    field :package, :string
    field :phone, :string
  end

end