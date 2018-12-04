defmodule RedPackProductionsWeb.PageController do
  use RedPackProductionsWeb, :controller

  # ==================================
  #               Index
  # ==================================
  def index(conn, _params) do

    # Get soundcloud songs
    soundcloud = Enum.map(CachedContentful.Api.getEntriesByType("soundcloud", get_session(conn, :locale)), fn(song) ->
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
  	packages = Enum.map(CachedContentful.Api.customEntrySearch("ordered_packages", packageOptions, true, get_session(conn, :locale)), fn(package) ->
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
  	testimonials = Enum.map(CachedContentful.Api.getEntriesByType("testimonial", get_session(conn, :locale)), fn(testimonial) ->
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
  end

  # ==================================
  #                FAQ
  # ==================================
  def question(conn, _params) do
    
    questions = Enum.map(CachedContentful.Api.getEntriesByType("questions", get_session(conn, :locale)), fn(question) ->
      
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
      |> render("faq.html", questions: questions) 
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

end
