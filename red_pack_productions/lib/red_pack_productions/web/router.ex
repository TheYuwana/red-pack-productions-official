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
  end

  # Other scopes may use custom stacks.
  # scope "/api", RedPackProductions.Web do
  #   pipe_through :api
  # end
end
