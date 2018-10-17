defmodule RedPackProductionsWeb.ApiController do
  use RedPackProductionsWeb, :controller

  alias RedPackProductionsWeb.ReservationView
  alias RedPackProductionsWeb.Utils

  plug :put_layout, false

  # ==================================
  #      Reset Contentful cache
  # ==================================
  def reset_cache(conn, _params) do
    packageOptions = %{"content_type": "packages", "order": "fields.order"}
    CachedContentful.Api.customEntrySearch("ordered_packages", packageOptions, true, get_session(conn, :locale))

    blogPostOptions = %{"content_type": "blogPost", "order": "sys.createdAt"}
    CachedContentful.Api.customEntrySearch("ordered_blogposts", blogPostOptions, true, get_session(conn, :locale))

    CachedContentful.Api.updateAssets()
    CachedContentful.Api.updateEntries()
    conn
    |> put_status(200)
    |> json(%{status: 200, message: "Cache Reset!"})
  end

  # ==================================
  #      Reservation dates
  # ==================================
  def reservation_dates(conn, _params) do 
  	
  	reservations = Enum.map(CachedContentful.Api.getEntriesByType("reservations", get_session(conn, :locale)), fn(reservation) ->
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

  # ==================================
  #      shopping basket
  # ==================================
  def add_to_basket(conn, %{"item_id" => item_id}) do
    basket = Utils.get_shopping_basket(conn)
    basket = if Enum.any?(basket, fn i -> i == item_id end) do
      basket
    else
      basket ++ [item_id]
    end

    conn
    |> put_session(:shopping_basket, basket)
    |> json(%{status: 200, message: "Item added"})
  end

  def remove_from_basket(conn, %{"item_id" => item_id}) do
    basket = Utils.get_shopping_basket(conn) -- [item_id]
    conn
    |> put_session(:shopping_basket, basket)
    |> json(%{status: 200, message: "Item removed"})
  end

  def clear_basket(conn, _) do
    basket = []
    conn
    |> put_session(:shopping_basket, basket)
    |> json(%{status: 200, message: "Basket cleared"})
  end

end