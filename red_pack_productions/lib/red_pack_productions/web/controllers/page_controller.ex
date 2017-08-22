defmodule RedPackProductions.Web.PageController do
  use RedPackProductions.Web, :controller

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

    IO.inspect packages
    #Get Testimonials form Contentful
  	testimonials = Enum.map(CachedContentful.Api.getEntriesByType("testimonial"), fn(testimonial) ->
      %{
        artist: testimonial["fields"]["artist"],
        comment: testimonial["fields"]["comment"]
      }
    end)

    render conn, "index.html", packages: packages, testimonials: testimonials
  end

  def samples(conn, _params) do
    render conn, "samples.html"
  end
end
