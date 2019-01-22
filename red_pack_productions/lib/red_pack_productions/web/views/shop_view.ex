defmodule RedPackProductionsWeb.ShopView do
  use RedPackProductionsWeb, :view

  def check_for_errors(changeset, field) do
  	if changeset.changes != %{} do
	  	case List.keyfind(changeset.errors, field, 0) do
	  	 	{_key,  {message, _valid}} -> message
	  	 	nil -> ""
	  	 end
  	else
  		""
  	end
  end

end
