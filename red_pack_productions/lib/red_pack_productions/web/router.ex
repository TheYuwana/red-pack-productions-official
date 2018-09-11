defmodule RedPackProductions.Web.Router do
  use RedPackProductions.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RedPackProductions.Web.Locale
  end

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
  end

  scope "/", RedPackProductions.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/samples", PageController, :samples
    get "/instruments", PageController, :instruments
    get "/contact", PageController, :contact
    get "/success", PageController, :success
    get "/packages/:package", PageController, :packages
    get "/question", PageController, :question
    get "/blog", PageController, :blog
    get "/blog/:slug", PageController, :blog_item
    get "/locale", PageController, :locale

    post "/reserve", PageController, :reserve
  end

  scope "/shop", RedPackProductions.Web do
    pipe_through :browser # Use the default browser stack
    get "/", ShopController, :index
    get "/product/:slug", ShopController, :show
  end

  scope "/api", RedPackProductions.Web do
    pipe_through :api 
    post "/resetcache", ApiController, :reset_cache
    get "/resetcache-manual", ApiController, :reset_cache
    get "/dates", ApiController, :reservation_dates

    scope "/mollie" , RedPackProductions.Web do
      post "/payment/update/:id", MollieController, :status_update
    end
  end

end
