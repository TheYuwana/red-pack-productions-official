defmodule RedPackProductions.Web.PageController do
  use RedPackProductions.Web, :controller
  use PlugEtsCache.Phoenix

  alias RedPackProductions.Mailer
  alias RedPackProductions.Email

  def index(conn, _params) do
    
    # Get soundcloud songs
    soundcloud = Enum.map(CachedContentful.Api.getEntriesByType("soundcloud"), fn(song) ->
      %{
        url: song["fields"]["url"],
        show: song["fields"]["showOnPage"]
      }
    end)

    # Get packages form Contentful
  	packages = Enum.map(CachedContentful.Api.getEntriesByType("packages"), fn(package) ->
      asset = CachedContentful.Api.getAssetById(package["fields"]["thumbnail"]["sys"]["id"])["fields"]
      
      %{
        title: package["fields"]["title"],
        subtitle: package["fields"]["subtitle"],
        items: package["fields"]["items"],
        normalPrice: package["fields"]["normalPrice"],
        redPackPrice: package["fields"]["redPackPrice"],
        priceText: package["fields"]["priceText"],
        thumbnail: asset["file"]["url"],
        buttonText: package["fields"]["buttonText"]
      }
    end)


    #Get Testimonials form Contentful
  	testimonials = Enum.map(CachedContentful.Api.getEntriesByType("testimonial"), fn(testimonial) ->
      asset = CachedContentful.Api.getAssetById(testimonial["fields"]["thumbnail"]["sys"]["id"])["fields"]
      %{
        artist: testimonial["fields"]["artist"],
        comment: testimonial["fields"]["comment"],
        thumbnail: asset["file"]["url"]
      }
    end)

    conn
      |> render("index.html", packages: packages, testimonials: testimonials, soundcloud: soundcloud)
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

  def packages(conn, %{"package" => packageName}) do

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

    # Get packages form Contentful
    packages = CachedContentful.Api.getEntriesByType("packages")

    # Get details for one package
    packageDetails = Enum.map(packages, fn(package) ->
      if packageName == package["fields"]["title"] do
        asset = CachedContentful.Api.getAssetById(package["fields"]["thumbnail"]["sys"]["id"])["fields"]
        htmlDetails =  Earmark.as_html(package["fields"]["details"])
        %{
          title: package["fields"]["title"],
          items: package["fields"]["items"],
          normalPrice: package["fields"]["normalPrice"],
          redPackPrice: package["fields"]["redPackPrice"],
          details: elem(htmlDetails, 1),
          thumbnail: asset["file"]["url"]
        }
      end
    end)
      |> Enum.filter(fn(x) -> x != nil end)
      |> Enum.fetch!(0)

    # Package list
    packages = Enum.map(packages, fn(package) ->
      asset = CachedContentful.Api.getAssetById(package["fields"]["thumbnail"]["sys"]["id"])["fields"]
      [ 
        key: "#{package["fields"]["title"]} - € #{package["fields"]["redPackPrice"]},-",
        value: package["fields"]["title"]
      ]
    end)

    conn
      |> render("packages.html", packages: packages, countries: countries, packageDetails: packageDetails, hours: hours)
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

  def question(conn, _params) do
    
    questions = Enum.map(CachedContentful.Api.getEntriesByType("questions"), fn(question) ->
      %{
          question: question["fields"]["question"],
          answer: question["fields"]["answer"]
        }
    end)

    conn
      |> render("question.html", questions: questions)  
  end

  def success(conn, _params) do
    conn
      |> render("success.html")
  end

end
