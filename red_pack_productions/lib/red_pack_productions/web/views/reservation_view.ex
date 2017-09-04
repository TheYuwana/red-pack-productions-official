defmodule RedPackProductions.Web.ReservationView do
  use RedPackProductions.Web, :view

  def render("index.json", %{reservations: reservations}) do
    reservations
  end

  def render("reset.json", _) do
    %{
    	status: :Ok,
    	message: "Cached succesfully cleared"
    }
  end

end