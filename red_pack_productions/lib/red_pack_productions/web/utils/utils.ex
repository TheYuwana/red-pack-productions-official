defmodule RedPackProductionsWeb.Utils do

	def format_error(errors) do
		Enum.map(errors, fn({k, v}) ->
		  k = k |> Atom.to_string
		  v = v |> Tuple.to_list |> List.first
		  %{"#{k}": v}
		end)
	end

	def get_shopping_basket(conn) do
		case Plug.Conn.get_session(conn, :shopping_basket) do
			nil -> []
			basket -> basket
		end
	end

	def parse_slug(title) do
		title
		|> String.normalize(:nfd)
		|> String.downcase()
		|> String.replace(~r/&amp;/, "")
		|> String.replace(~r/&nbsp;/, " ")
		|> String.replace(~r/[^a-z-0-9\s]/u, "") 
		|> String.replace(~r/\s/, "-")
		|> String.replace(~r/--/, "-")
	end

end