defmodule RedPackProductions.Web.Router do
  use RedPackProductions.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
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

    post "/reserve", PageController, :reserve
  end

  scope "/api", RedPackProductions.Web do
    pipe_through :api 
    post "/resetcache", ApiController, :reset_cache
    get "/resetcache-manual", ApiController, :reset_cache
    get "/dates", ApiController, :reservation_dates
  end

end
