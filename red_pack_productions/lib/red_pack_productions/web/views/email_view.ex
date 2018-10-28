defmodule RedPackProductionsWeb.EmailView do
  use RedPackProductionsWeb, :view

  def parse_hours(details) do
  	if Map.has_key?(details, "hours") do
  		Enum.map_join(details["hours"], ", ", fn hour -> hour end)
  	else
  		""
  	end
  end

  def parse_orders(order) do
  	Enum.map(order["fields"]["details"]["nl"], fn product ->
  		 "<tr>
  		 	<td>#{product["id"]}</td>
  		 	<td>#{product["title"]}</td>
  		 	<td>#{product["price"]}</td>
  		 </tr>"
  	end)
  	|> List.to_string()
  end

  def parse_orders_client(order) do
    Enum.map(order["fields"]["details"]["nl"], fn product ->
       "<tr>
        <td>#{product["title"]}</td>
        <td>#{product["price"]}</td>
       </tr>"
    end)
    |> List.to_string()
  end

  def order_total(order) do
  	Enum.reduce(order["fields"]["details"]["nl"], 0, fn product, acc -> 
  		acc + product["price"]
  	end)
  end

end