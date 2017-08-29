defmodule RedPackProductions.Web.ApiController do
  use RedPackProductions.Web, :controller
  use PlugEtsCache.Phoenix

  alias RedPackProductions.Web.ReservationView

  plug :put_layout, false

  def reservation_dates(conn, _params) do 
  	
  	reservations = Enum.map(CachedContentful.Api.getEntriesByType("reservations"), fn(reservation) ->
      if reservation["fields"]["approved"] do
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

        %{
          start: %{
            date: Enum.at(startDate, 0),
            hour: startHour
          },
          end: %{
            date: Enum.at(endDate, 0),
            hour: endHour
          }
        }
      end

    end)

  	conn
	    |> put_status(200)
	    |> render(ReservationView, "index.json", reservations: reservations)
	    #|> cache_response
  end

end