defmodule RedPackProductionsWeb.Basket do
  import Plug.Conn

  alias RedPackProductionsWeb.Utils

  def init(_) do
  end

  def call(conn, _) do
    # TODO: CHeck for nil
  	products = CachedContentful.Api.getEntriesByType("products", get_session(conn, :locale))
  	basket = Utils.get_shopping_basket(conn)
  	|> Enum.map(fn id -> 
  		product = Enum.find(products, fn product -> id == product["id"] end)
  		%{
  			title: product["fields"]["title"],
  			price: product["fields"]["newPrice"],
  			id: id
  		}
  	end)
    conn
    |> assign(:basket, basket)
  end
end
