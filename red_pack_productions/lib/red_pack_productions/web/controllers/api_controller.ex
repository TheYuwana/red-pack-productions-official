defmodule RedPackProductions.Web.ApiController do
  use RedPackProductions.Web, :controller
  use PlugEtsCache.Phoenix

  alias RedPackProductions.Web.ReservationView

  plug :put_layout, false

  def reservation_dates(conn, _params) do 
  	
  	reservations = Enum.map(CachedContentful.Api.getEntriesByType("reservations"), fn(reservation) ->
      startDate = String.split(reservation["fields"]["startDate"], "T")
      startHour = startDate
        |> Enum.at(1)
        |> String.split("+")
        |> Enum.at(0)

      endDate = String.split(reservation["fields"]["endDate"], "T")
      endHour = endDate
        |> Enum.at(1)
        |> String.split("+")
        |> Enum.at(0)
        
      startNumber = startHour |> String.split(":") |> Enum.at(0) |> String.to_integer()
      endNumber = endHour |> String.split(":") |> Enum.at(0) |> String.to_integer()
      reservedHours = for item <- startNumber..endNumber do
        "#{item}:00"
      end

      %{
        reservedDate: Enum.at(startDate, 0),
        reservedHours: reservedHours
      }
    end)

  	conn
	    |> put_status(200)
	    |> render(ReservationView, "index.json", reservations: reservations)
  end

end