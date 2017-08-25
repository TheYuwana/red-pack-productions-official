defmodule RedPackProductions.Web.PageController do
  use RedPackProductions.Web, :controller
  use PlugEtsCache.Phoenix

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

end
