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

    suggestions = products
    |> Enum.reject(fn p -> p["id"] == product.id end)
    |> Enum.take_random(4)
    |> Enum.map(fn p -> 
      photo = CachedContentful.Api.getAssetById(p["fields"]["photo"]["sys"]["id"])["fields"]
      sample_link = CachedContentful.Api.getAssetById(p["fields"]["sampleLink"]["sys"]["id"])["fields"]
      category =  if p["fields"]["category"] == nil do
        ""
      else
        p["fields"]["category"]
      end
      %{
        id: p["id"],
        title: p["fields"]["title"],
        category: p["fields"]["category"],
        category_class: Utils.parse_slug(category),
        slug: p["fields"]["slug"],
        old_price: p["fields"]["oldPrice"],
        new_price: p["fields"]["newPrice"],
        description: p["fields"]["description"],
        sample_link: "https:" <> sample_link["file"]["url"],
        photo: photo["file"]["url"]
      }
    end)

    conn
    |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
    |> assign(:title, "Red Pack Productions - Shop - #{product.title}")
    |> render("show.html", product: product, suggestions: suggestions)
  end

  # ==================================
  #         Checkout process
  # ==================================
  def checkout_page(conn, _) do

    products = conn.assigns.basket
    total_price = Enum.reduce(products, 0, fn p, acc -> acc + p.price end)

    case Mollie.create_payment_request(total_price, products) do
      {:ok, payment_request} ->

        checkout_url = payment_request["_links"]["checkout"]["href"]
        payment_id = payment_request["id"]

        conn
        |> put_session(:payment_id, payment_id)
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - payment result")
        |> render("checkout.html", checkout_url: checkout_url, total_price: total_price)

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
  def process_checkout(conn, %{"contact" => contact}) do

    # Create new order on Contentful
    # Get order id and create new mollie payment request
    # If all success, then redirect to mollie checkout
    # If fail, then redirect to wbe checkout and show errors 

    conn
    |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
    |> assign(:title, "Red Pack Productions - Shop - payment result")
    |> render("payment_loading.html")
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