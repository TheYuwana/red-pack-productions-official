defmodule RedPackProductions.Web.ReservationView do
  use RedPackProductions.Web, :view

  def render("index.json", %{reservations: reservations}) do
    reservations
  end

end