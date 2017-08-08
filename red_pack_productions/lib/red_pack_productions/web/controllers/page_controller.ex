defmodule RedPackProductions.Web.PageController do
  use RedPackProductions.Web, :controller

  def index(conn, _params) do


    render conn, "index.html", products: [1, 2, 3, 4, 5, 6, 7, 8]
  end
end
