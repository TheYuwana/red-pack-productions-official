defmodule RedPackProductionsWeb.ShopController do
  use RedPackProductionsWeb, :controller

  alias RedPackProductions.Mollie
  alias RedPackProductionsWeb.Utils

  # ==================================
  #               Index
  # ==================================
  def index(conn, _) do

    # Get poducts
    products = Enum.map(CachedContentful.Api.getEntriesByType("products", get_session(conn, :locale)), fn(product) ->
      photo = CachedContentful.Api.getAssetById(product["fields"]["photo"]["sys"]["id"])["fields"]
      sample_link = CachedContentful.Api.getAssetById(product["fields"]["sampleLink"]["sys"]["id"])["fields"]
      
      category =  if product["fields"]["category"] == nil do
        ""
      else
        product["fields"]["category"]
      end


      %{
        id: product["id"],
        title: product["fields"]["title"],
        category: product["fields"]["category"],
        category_class: Utils.parse_slug(category),
        slug: product["fields"]["slug"],
        old_price: product["fields"]["oldPrice"],
        new_price: product["fields"]["newPrice"],
        description: product["fields"]["description"],
        sample_link: "https:" <> sample_link["file"]["url"],
        photo: photo["file"]["url"]
      }
    end)

    categories = Enum.map(products, fn p -> 
      %{
        category: p.category,
        category_class: p.category_class,
      }
    end)
    |> Enum.uniq()

    IO.inspect categories

  	conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Shop")
      |> render("index.html", products: products)
  end

  # ==================================
  #         Product Details
  # ==================================
  def show(conn, %{"slug" => slug}) do
    
    # Get all products
    products = CachedContentful.Api.getEntriesByType("products", get_session(conn, :locale))
    selected_product = Enum.find(products, fn product -> slug == product["fields"]["slug"] end)
    photo = CachedContentful.Api.getAssetById(selected_product["fields"]["photo"]["sys"]["id"])["fields"]
    sample_link = CachedContentful.Api.getAssetById(selected_product["fields"]["sampleLink"]["sys"]["id"])["fields"]

    # IO.inspect Enum.find(products, fn product -> slug == product["fields"]["slug"] end)
    # Do a nil check for 404
    product = %{
      id: selected_product["id"],
      title: selected_product["fields"]["title"],
      category: selected_product["fields"]["category"],
      slug: selected_product["fields"]["slug"],
      old_price: selected_product["fields"]["oldPrice"],
      new_price: selected_product["fields"]["newPrice"],
      description: selected_product["fields"]["description"],
      sample_link: "https:" <> sample_link["file"]["url"],
      photo: photo["file"]["url"]
    }

    IO.inspect product

    conn
    |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
    |> assign(:title, "Red Pack Productions - Shop - #{product.title}")
    |> render("show.html", product: product)
  end

  # ==================================
  #         Checkout process
  # ==================================
  def checkout_page(conn, _) do
    case Mollie.create_payment_request() do
      {:ok, payment_request} ->

        checkout_url = payment_request["_links"]["checkout"]["href"]
        payment_id = payment_request["id"]
        basket = Utils.get_shopping_basket(conn)

        conn
        |> put_session(:payment_id, payment_id)
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - payment result")
        |> render("checkout.html", checkout_url: checkout_url, basket: basket)

      {:error, _error} ->
        conn
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - error")
        |> render("error.html")
    end
  end

  # ==================================
  #         Payment loading
  # ==================================
  def payment_loading_page(conn, _) do
    conn
    |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
    |> assign(:title, "Red Pack Productions - Shop - payment result")
    |> render("payment_loading.html")
  end

  # ==================================
  #         Payment result
  # ==================================
  def payment_result_page(conn, _) do
    case Mollie.get_payment("get_session(conn, :payment_id)") do
      {:ok, payment} ->
        payment_status = payment["status"]

        conn
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - payment result")
        |> render("payment_result.html", payment_status: payment_status)
      {:error, _error} ->
        conn
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - error")
        |> render("error.html")
    end    
  end

  # REMOVE THIS
  def error_page(conn, _) do
    conn
    |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
    |> assign(:title, "Red Pack Productions - Shop - error")
    |> render("error.html")
  end

end