defmodule RedPackProductionsWeb.ShopController do
  use RedPackProductionsWeb, :controller

  alias RedPackProductions.Mollie

  # ==================================
  #               Index
  # ==================================
  def index(conn, _) do

    # Get poducts
    products = Enum.map(CachedContentful.Api.getEntriesByType("products", get_session(conn, :locale)), fn(product) ->
      photo = CachedContentful.Api.getAssetById(product["fields"]["photo"]["sys"]["id"])["fields"]
      sample_link = CachedContentful.Api.getAssetById(product["fields"]["sampleLink"]["sys"]["id"])["fields"]
      %{
        title: product["fields"]["title"],
        subtitle: product["fields"]["subtitle"],
        slug: product["fields"]["slug"],
        old_price: product["fields"]["oldPrice"],
        new_price: product["fields"]["newPrice"],
        description: product["fields"]["description"],
        sample_link: sample_link["file"]["url"],
        photo: photo["file"]["url"]
      }
    end) 

  	conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Shop")
      |> render("index.html", products: products)
  end

  # ==================================
  #         Product Details
  # ==================================
  def show(conn, %{"slug" => slug}) do
    
    # # Get all products
    # products = CachedContentful.Api.getEntriesByType("products", get_session(conn, :locale))

    # # Get product by slug
    # product = Enum.map(products, fn(product) -> 
    #   if slug == product["fields"]["slug"] do
    #     photo = CachedContentful.Api.getAssetById(product["fields"]["photo"]["sys"]["id"])["fields"]
    #     sample_link = CachedContentful.Api.getAssetById(product["fields"]["sampleLink"]["sys"]["id"])["fields"]
    #     %{
    #       title: product["fields"]["title"],
    #       subtitle: product["fields"]["subtitle"],
    #       slug: product["fields"]["slug"],
    #       old_price: product["fields"]["oldPrice"],
    #       new_price: product["fields"]["newPrice"],
    #       description: product["fields"]["description"],
    #       sample_link: sample_link["file"]["url"],
    #       photo: photo["file"]["url"]
    #     }
    #   end
    # end)
    #   |> Enum.filter(fn(x) -> x != nil end)
    #   |> Enum.fetch!(0)

    # conn
    #   |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
    #   |> assign(:title, "Red Pack Productions - Shop - #{product.title}")
    #   |> render("show.html", product: product)

    conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Shop - test")
      |> render("show.html")
  end

  def test(conn, _) do
    IO.puts "========== Get all Payments =========="
    IO.inspect Mollie.get_all_payments()

    IO.puts "========== Get payment =========="
    payment_request = Mollie.get_payment("tr_frFP2RPFB3")

    IO.inspect payment_request

    conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Shop")
      |> render("index.html", payment_request: payment_request)
  end

end