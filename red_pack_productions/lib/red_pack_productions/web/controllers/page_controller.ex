defmodule RedPackProductions.Web.PageController do
  use RedPackProductions.Web, :controller
  use PlugEtsCache.Phoenix

  alias RedPackProductions.Mailer
  alias RedPackProductions.Email

  def index(conn, _params) do
    
    # Get packages form Contentful
  	packages = Enum.map(CachedContentful.Api.getEntriesByType("packages"), fn(package) ->
      asset = CachedContentful.Api.getAssetById(package["fields"]["thumbnail"]["sys"]["id"])["fields"]
      %{
        title: package["fields"]["title"],
        items: package["fields"]["items"],
        normalPrice: package["fields"]["normalPrice"],
        redPackPrice: package["fields"]["redPackPrice"],
        thumbnail: asset["file"]["url"]
      }
    end)

    #Get Testimonials form Contentful
  	testimonials = Enum.map(CachedContentful.Api.getEntriesByType("testimonial"), fn(testimonial) ->
      %{
        artist: testimonial["fields"]["artist"],
        comment: testimonial["fields"]["comment"]
      }
    end)

    conn
      |> render("index.html", packages: packages, testimonials: testimonials)
      |> cache_response
  end

  def samples(conn, _params) do
    conn
      |> render("samples.html")
      |> cache_response
  end

  def instruments(conn, _params) do
    conn
      |> render("instruments.html")
      |> cache_response
  end

  def contact(conn, _params) do

    # Hours
    hours = ["10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00"]

    # Get packages form Contentful
    packages = Enum.map(CachedContentful.Api.getEntriesByType("packages"), fn(package) ->
      asset = CachedContentful.Api.getAssetById(package["fields"]["thumbnail"]["sys"]["id"])["fields"]
      [ 
        key: "#{package["fields"]["title"]} - € #{package["fields"]["redPackPrice"]},-",
        value: package["fields"]["title"]
      ]
    end)

    # Get countries
    countries = Enum.map(Countries.all, fn(country) -> country.name end)
    conn
      |> render("contact.html", countries: countries, packages: packages, hours: hours)
      |> cache_response
  end

  def reserve(conn, %{"reservation" => reservation}) do
    Email.reservation(reservation) |> Mailer.deliver_now
    conn
      |> redirect(to: page_path(conn, :success))
  end

  def success(conn, _params) do
    conn
      |> render("success.html")
  end

end
