defmodule RedPackProductionsWeb.Router do
  use RedPackProductionsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RedPackProductionsWeb.Locale
  end

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
  end

  scope "/", RedPackProductionsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/success", PageController, :success
    get "/question", PageController, :question
    get "/locale", PageController, :locale

    scope "/blog" do
      get "/", BlogController, :index
      get "/:slug", BlogController, :show
    end

    scope "/packages" do
      get "/:package", PackageController, :show
      post "/reserve", PackageController, :reserve
    end
  end

  # scope "/shop", RedPackProductionsWeb do
  #   pipe_through :browser # Use the default browser stack
  #   get "/", ShopController, :index
  #   get "/product/:slug", ShopController, :show
  # end

  # scope "/api", RedPackProductionsWeb do
  #   pipe_through :api 
  #   post "/resetcache", ApiController, :reset_cache
  #   get "/resetcache-manual", ApiController, :reset_cache
  #   get "/dates", ApiController, :reservation_dates

  #   scope "/mollie" , RedPackProductionsWeb do
  #     post "/payment/update/:id", MollieController, :status_update
  #   end
  # end
end
