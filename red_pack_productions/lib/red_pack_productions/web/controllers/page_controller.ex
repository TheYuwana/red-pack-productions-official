defmodule RedPackProductions.Web.PageController do
  use RedPackProductions.Web, :controller
  use PlugEtsCache.Phoenix

  alias RedPackProductions.Mailer
  alias RedPackProductions.Email
  alias RedPackProductions.Web.Reservation
  alias RedPackProductions.Web.Context
  
  @hours ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]

  # ==================================
  #               Index
  # ==================================
  def index(conn, _params) do

    # Get soundcloud songs
    soundcloud = Enum.map(CachedContentful.Api.getEntriesByType("soundcloud"), fn(song) ->
      %{
        url: song["fields"]["url"],
        show: song["fields"]["showOnPage"]
      }
    end)

    # Get packages form Contentful
    packageOptions = %{
      "content_type": "packages",
      "order": "fields.order"
    }
  	packages = Enum.map(CachedContentful.Api.customEntrySearch("ordered_packages", packageOptions, false), fn(package) ->
      asset = CachedContentful.Api.getAssetById(package["fields"]["thumbnail"]["sys"]["id"])["fields"]
      
      items = case package["fields"]["items"] do
        nil ->
          []
        _ ->
          package["fields"]["items"]
      end   

      %{
        title: package["fields"]["title"],
        subtitle: package["fields"]["subtitle"],
        items: items,
        normalPriceText: package["fields"]["normalPriceText"],
        redPackPrice: package["fields"]["redPackPrice"],
        priceText: package["fields"]["priceText"],
        thumbnail: asset["file"]["url"],
        slug: package["fields"]["slug"],
        buttonText: package["fields"]["buttonText"],
        order: package["fields"]["order"]
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
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions")
      |> render("index.html", packages: packages, testimonials: testimonials, soundcloud: soundcloud)
      |> cache_response
  end

  # ==================================
  #            Samples
  # ==================================
  def samples(conn, _params) do
    conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Samples")
      |> render("samples.html")
      |> cache_response
  end

  # ==================================
  #          Instruments
  # ==================================
  def instruments(conn, _params) do
    conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Instruments")
      |> render("instruments.html")
      |> cache_response
  end

  # ==================================
  #           Packages
  # ==================================
  def packages(conn, %{"package" => packageName}) do
    changeset = Context.change_reservation(%Reservation{})
    render_package_form(conn, packageName, changeset)
  end

  def reserve(conn, %{"reservation" => reservation}) do
    changeset = Context.create_reservation(reservation)
    case changeset.valid? do
      true ->
        Email.reservation(reservation) |> Mailer.deliver_now
        conn
          |> redirect(to: page_path(conn, :success))
      false ->
        packageName = reservation["package"]
        render_package_form(conn, packageName, changeset)    
    end
  end

  def render_package_form(conn, packageName, changeset) do
    # Get packages form Contentful
    packageOptions = %{
      "content_type": "packages",
      "order": "fields.order"
    }
    packagesFromContentful = CachedContentful.Api.customEntrySearch("ordered_packages", packageOptions, false)

    # Get countries
    countries = Enum.map(Countries.all, fn(country) -> country.name end)

    # Get details for one package
    packageDetails = Enum.map(packagesFromContentful, fn(package) ->
      if packageName == package["fields"]["slug"] do
        asset = CachedContentful.Api.getAssetById(package["fields"]["thumbnail"]["sys"]["id"])["fields"]
        htmlDetails = Earmark.as_html(package["fields"]["details"])
        %{
          title: package["fields"]["title"],
          items: package["fields"]["items"],
          redPackPrice: package["fields"]["redPackPrice"],
          details: elem(htmlDetails, 1),
          thumbnail: asset["file"]["url"],
          slug: package["fields"]["slug"]
        }
      end
    end)
      |> Enum.filter(fn(x) -> x != nil end)
      |> Enum.fetch!(0)

    # Get selected package
    selectedPackage = Enum.map(packagesFromContentful, fn(package) -> 
      if packageName == package["fields"]["slug"] do 
        package["fields"]["slug"]
      end
    end)
      |> Enum.filter(fn(x) -> x != nil end)
      |> Enum.fetch!(0)

    # Package list
    packages = Enum.map(packagesFromContentful, fn(package) ->
      [ 
        key: "#{package["fields"]["title"]} - € #{package["fields"]["redPackPrice"]},-",
        value: package["fields"]["slug"]
      ]
    end)

    conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Packages")
      |> render("packages.html", packages: packages, countries: countries, packageDetails: packageDetails, hours: @hours, selectedPackage: selectedPackage, changeset: changeset)
      |> cache_response

  end

  # ==================================
  #               Blog
  # ==================================
  def blog(conn, _params) do

    blogPosts = CachedContentful.Api.customEntrySearch(
      "ordered_blogposts",
      %{"content_type": "blogPost", "order": "sys.createdAt"}, 
      false
    )

    blogPosts = Enum.map(blogPosts, fn(post) ->

      thumbnail = if post["fields"]["photos"] != nil do
        photo = CachedContentful.Api.getAssetById(List.first(post["fields"]["photos"])["sys"]["id"])
        "#{photo["fields"]["file"]["url"]}?w=250"
      else
        nil
      end

      %{
          title: post["fields"]["title"],
          slug: post["fields"]["slug"],
          thumbnail: thumbnail,
        }
    end)

    conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Blog")
      |> render("blog_list.html", blogPosts: blogPosts) 
  end

  def blog_item(conn, %{"slug" => slug}) do

    blogposts = CachedContentful.Api.getEntriesByType("blogPost");

    # Get details for one blog post
    blogPost = Enum.map(blogposts, fn(post) ->
      if slug == post["fields"]["slug"] do

        photo = if post["fields"]["photos"] != nil do
          photo = CachedContentful.Api.getAssetById(List.first(post["fields"]["photos"])["sys"]["id"])
          photo["fields"]["file"]["url"]
        else
          "/images/rp_logo.png"
        end

        htmlDetails = Earmark.as_html(post["fields"]["content"])

        %{
          title: post["fields"]["title"],
          subtitle: post["fields"]["subtitle"],
          content: elem(htmlDetails, 1),
          slug: post["fields"]["slug"],
          photo: photo,
        }
      end
    end)
      |> Enum.filter(fn(x) -> x != nil end)
      |> Enum.fetch!(0)

    conn
      |> assign(:og_description, "#{blogPost.title}")
      |> assign(:title, "Red Pack Productions - #{blogPost.title}")
      |> render("blog.html", blogPost: blogPost) 
  end

  # ==================================
  #           Question
  # ==================================
  def question(conn, _params) do
    
    questions = Enum.map(CachedContentful.Api.getEntriesByType("questions"), fn(question) ->
      
      htmlDetails = case question["fields"]["answer"] do
        nil -> 
            ""
          _ -> 
            result = Earmark.as_html(question["fields"]["answer"])
            elem(result, 1)
      end

      %{
          question: question["fields"]["question"],
          answer: htmlDetails
        }
    end)

    conn
      |> assign(:og_description, "Everything you need to know!")
      |> assign(:title, "Red Pack Productions - FAQ")
      |> render("question.html", questions: questions) 
  end

  # ==================================
  #            Locale
  # ==================================
  def locale(conn, %{"locale" => locale, "redirect" => redirect}) do
    Gettext.put_locale(RedPackProductions.Web.Gettext, locale)
    conn
    |> put_session(:locale, locale)
    |> redirect(to: redirect)
  end
  def locale(conn, %{"locale" => locale}), do: locale(conn, %{"locale" => locale, "redirect" => page_path(conn, :index)})
  def locale(conn, _), do: locale(conn, %{"locale" => "nl", "redirect" => page_path(conn, :index)})

  # ==================================
  #            Success
  # ==================================
  def success(conn, _params) do
    conn
      |> assign(:og_description, "HOW ARE YOU EVEN HERE!???")
      |> assign(:title, "Red Pack Productions - SUCCESS")
      |> render("success.html")
  end

  # ==================================
  #            Helpers
  # ==================================
  def format_error(errors) do
    Enum.map(errors, fn({k, v}) ->
      k = k |> Atom.to_string
      v = v |> Tuple.to_list |> List.first
      %{"#{k}": v}
    end)
  end

end
