defmodule RedPackProductions.Web.PageController do
  use RedPackProductions.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
