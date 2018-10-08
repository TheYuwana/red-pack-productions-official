defmodule RedPackProductionsWeb.Utils do

	def format_error(errors) do
		Enum.map(errors, fn({k, v}) ->
		  k = k |> Atom.to_string
		  v = v |> Tuple.to_list |> List.first
		  %{"#{k}": v}
		end)
	end

end