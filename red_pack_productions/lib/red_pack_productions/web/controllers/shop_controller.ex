defmodule RedPackProductionsWeb.ShopController do
  use RedPackProductionsWeb, :controller

  alias RedPackProductions.Mollie
  alias RedPackProductionsWeb.Utils
  alias RedPackProductions.ContentfulCms
  alias RedPackProductions.Email
  alias RedPackProductions.Mailer
  alias RedPackProductionsWeb.Context
  alias RedPackProductionsWeb.Order

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
        sample_link: "https:" <> sample_link["file"]["url"],
        photo: photo["file"]["url"]
      }
    end)

    categories = Enum.map(products, fn p -> 
      %{
        title: p.category,
        class: p.category_class
      }
    end)
    |> Enum.uniq()

  	conn
      |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
      |> assign(:title, "Red Pack Productions - Shop")
      |> render("index.html", products: products, categories: categories)
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

    htmlDetails = Earmark.as_html(selected_product["fields"]["description"])
    # Do a nil check for 404
    product = %{
      id: selected_product["id"],
      title: selected_product["fields"]["title"],
      category: selected_product["fields"]["category"],
      slug: selected_product["fields"]["slug"],
      old_price: selected_product["fields"]["oldPrice"],
      new_price: selected_product["fields"]["newPrice"],
      price_text: selected_product["fields"]["priceText"],
      description: elem(htmlDetails, 1),
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
    changeset = Context.change_order(%Order{})

    conn
    |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
    |> assign(:title, "Red Pack Productions - Shop - payment result")
    |> render("checkout.html", total_price: total_price, changeset: changeset)
  end

  # ==================================
  #         Payment loading
  # ==================================
  def process_checkout(conn, %{"contact" => contact}) do

    products = conn.assigns.basket
    total_price = Enum.reduce(products, 0, fn p, acc -> acc + p.price end)

    data = %{
      first_name: contact["first_name"],
      last_name: contact["last_name"],
      email: contact["email"],
      total_price: total_price,
      details: products
    }

    with(
      {:ok, :valid} <- Context.create_order(data),
      {:ok, order_data} <- ContentfulCms.create_order(data),
      {:ok, published_data} <- ContentfulCms.publish_order(order_data["sys"]["id"], order_data["sys"]["version"]),
      {:ok, payment_request} <- Mollie.create_payment_request(total_price, order_data["sys"]["id"]),
      {:ok, _updated_order} <- ContentfulCms.update_order(
          payment_request["id"], 
          payment_request["metadata"]["order_id"], 
          payment_request["status"],
          published_data)
    )do
        checkout_url = payment_request["_links"]["checkout"]["href"]
        conn
        |> put_session(:payment_id, payment_request["id"])
        |> redirect(external: checkout_url)
    else
      {:error, changeset} ->
        products = conn.assigns.basket
        total_price = Enum.reduce(products, 0, fn p, acc -> acc + p.price end)

        conn
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - payment result")
        |> render("checkout.html", total_price: total_price, changeset: changeset)
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
    with(
      mollie_payment_id when not is_nil(mollie_payment_id) <- get_session(conn, :payment_id),
      {:ok, mollie_payment} = Mollie.get_payment(mollie_payment_id)
    )do
      case(mollie_payment["status"])do
        "canceled" ->
          conn
          |> redirect(to: "/shop/checkout")
        "expired" ->
          conn
          |> redirect(to: "/shop/checkout")
        "failed" ->
          conn
          |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
          |> assign(:title, "Red Pack Productions - Shop - error")
          |> render("error.html")
        _ ->
          conn
          |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
          |> assign(:title, "Red Pack Productions - Shop - payment result")
          |> render("payment_loading.html")
      end
    else
      nil ->
        conn
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - error")
        |> render("error.html")
      {:error, _error} ->
        conn
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - error")
        |> render("error.html")
    end
  end

  # ==================================
  #         Payment result
  # ==================================
  def payment_result_page(conn, _) do
    with(
      mollie_payment_id when not is_nil(mollie_payment_id) <- get_session(conn, :payment_id),
      {:ok, mollie_payment} = Mollie.get_payment(mollie_payment_id),
      {:ok, order} = ContentfulCms.get_order(mollie_payment["metadata"]["order_id"]),
      {:ok, updated_order} <- ContentfulCms.update_order(
            mollie_payment["id"], 
            mollie_payment["metadata"]["order_id"], 
            mollie_payment["status"],
            order)
    )do
      case(mollie_payment["status"])do
        "canceled" ->
          conn
          |> redirect(to: "/shop/checkout")
        "expired" ->
          conn
          |> redirect(to: "/shop/checkout")
        "failed" ->
          conn
          |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
          |> assign(:title, "Red Pack Productions - Shop - error")
          |> render("error.html")
        _ ->
          Mailer.deliver_now(Email.order_confirmation(updated_order))
          Mailer.deliver_now(Email.order_confirmation_client(updated_order, updated_order["fields"]["consumerEmail"]["nl"]))
          conn
          |> put_session(:shopping_basket, [])
          |> put_session(:payment_id, nil)
          |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
          |> assign(:title, "Red Pack Productions - Shop - payment result")
          |> render("payment_result.html", payment_status: mollie_payment["status"])
      end
    else
      nil ->
        conn
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - error")
        |> render("error.html")
      {:error, _error} ->
        conn
        |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
        |> assign(:title, "Red Pack Productions - Shop - error")
        |> render("error.html")
    end
  end

  def error_page(conn, _) do
    conn
    |> assign(:og_description, "Low budget/HIGH QUALITY Audio-Recording studio.")
    |> assign(:title, "Red Pack Productions - Shop - error")
    |> render("error.html")
  end

end