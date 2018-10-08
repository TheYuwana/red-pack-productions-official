defmodule RedPackProductionsWeb.PackageController do
  use RedPackProductionsWeb, :controller

  alias RedPackProductions.Mailer
  alias RedPackProductions.Email
  alias RedPackProductionsWeb.Reservation
  alias RedPackProductionsWeb.Context

  @hours ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]

  # ==================================
  #           	  Show
  # ==================================
  def show(conn, %{"package" => packageName}) do
    changeset = Context.change_reservation(%Reservation{})
    render_package_form(conn, packageName, changeset)
  end

  def reserve(conn, %{"reservation" => reservation}) do
    changeset = Context.create_reservation(reservation)
    case changeset.valid? do
      true ->

        Email.reservation(reservation)
          |> Mailer.deliver_now()
          
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
    packagesFromContentful = CachedContentful.Api.customEntrySearch("ordered_packages", packageOptions, true, get_session(conn, :locale))

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
      |> render("show.html", packages: packages, countries: countries, packageDetails: packageDetails, hours: @hours, selectedPackage: selectedPackage, changeset: changeset)
  end

end